codeunit 50000 "Job Module Customs"
{
    procedure CreatePurchaseInvoice(JobPlanningLine: Record "Job Planning Line")
    var
        Job: Record Job;
        JobPlanningLine2: Record "Job Planning Line";
        PurchaseHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Resource: Record Resource;
        PrevJobResouceNo: Code[20];
        JobPostingGroup: Record "Job Posting Group";
        InvoicesCreated: Boolean;
        Err001: Label 'No lines to create purchase Order.';
        Err002: Label 'Please Post the existing Order - %1 which is already created for resource - %2.';
        SuccessText: Label 'Purchase Order created successfully. Do you want to navigate to those Orders?';
    begin
        InvoicesCreated := false;
        JobPlanningLine.SetCurrentKey("No.");
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SetFilter(Quantity, '<>0');
        JobPlanningLine.SetFilter("Qty. to Transfer to Purch. Inv", '<>0');
        IF Not JobPlanningLine.FindFirst() then
            Error(Err001);

        JobPlanningLine.SetCurrentKey("No.");
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SetFilter(Quantity, '<>0');
        JobPlanningLine.SetFilter("Qty. to Transfer to Purch. Inv", '<>0');
        JobPlanningLine.SetFilter("Update Purchase Order", '=%1', '');
        if JobPlanningLine.FindSet() then begin
            repeat
                if PrevJobResouceNo <> JobPlanningLine."No." then begin
                    PrevJobResouceNo := JobPlanningLine."No.";
                    Job.Get(JobPlanningLine."Job No.");
                    if (Resource.Get(JobPlanningLine."No.")) and (Resource."Sub-Contracting Resource") then begin
                        if PurchLine.Get(PurchLine."Document Type"::Order, JobPlanningLine."Subcon. Invoice No.", JobPlanningLine."Subcon. Invoice Line No.") then
                            Error(Err002, JobPlanningLine."Subcon. Invoice No.", PrevJobResouceNo);
                        if CreatePurchaseHeader(Job, WorkDate(), JobPlanningLine, PurchaseHeader, Resource) then begin
                            InvoicesCreated := true;
                            JobPostingGroup.Get(Job."Job Posting Group");
                            JobPostingGroup.TestField("Sub-Contracting Accrual cost");
                            CreateFirstPurchaseLine(JobPlanningLine, PurchaseHeader);
                            JobPlanningLine2.Reset();
                            JobPlanningLine2.CopyFilters(JobPlanningLine);
                            JobPlanningLine2.SetRange("No.", JobPlanningLine."No.");
                            if JobPlanningLine2.FindSet() then
                                repeat
                                    CreatePurchaseLine(JobPlanningLine2, PurchaseHeader, Job, JobPostingGroup);
                                until JobPlanningLine2.Next() = 0;
                        end;
                    end;
                end;
            until JobPlanningLine.Next() = 0;
            if InvoicesCreated then begin
                if Confirm(SuccessText, false) then begin
                    ShowCreatedPurchaseInvoices(JobPlanningLine);
                end else
                    exit;
            end else
                Error(Err001);
        end else BEGIN
            //Error(Err001);
            JobPlanningLine.Reset();
            JobPlanningLine.SetCurrentKey("No.");
            JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
            JobPlanningLine.SetFilter(Quantity, '<>0');
            JobPlanningLine.SetFilter("Qty. to Transfer to Purch. Inv", '<>0');
            JobPlanningLine.SetFilter("Update Purchase Order", '<>%1', '');
            if JobPlanningLine.FindSet() then Begin
                repeat
                    UpdatePurchaseLine(JobPlanningLine);
                until JobPlanningLine.Next = 0;
                Message('Updated.');
            end;
        End;
    end;

    local procedure CreatePurchaseHeader(Job: Record Job; PostingDate: Date; JobPlanningLine: Record "Job Planning Line"; var PurchaseHeader: Record "Purchase Header"; Resource: Record Resource): Boolean
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
    begin
        Clear(PurchaseHeader);
        PurchaseSetup.Get();
        PurchaseHeader.Init();
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseSetup.TestField("Invoice Nos.");
        PurchaseHeader."Posting Date" := PostingDate;
        PurchaseHeader.Insert(true);

        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", Resource."Sub-Con. Resource Vendor");
        PurchaseHeader.Validate("Pay-to Vendor No.", Resource."Sub-Con. Resource Vendor");

        if Job."Payment Method Code" <> '' then
            PurchaseHeader.Validate("Payment Method Code", Job."Payment Method Code");
        if Job."Payment Terms Code" <> '' then
            PurchaseHeader.Validate("Payment Terms Code", Job."Payment Terms Code");

        if Job."Currency Code" <> '' then
            PurchaseHeader.Validate("Currency Code", Job."Currency Code")
        else
            PurchaseHeader.Validate("Currency Code", Job."Invoice Currency Code");
        if PostingDate <> 0D then
            PurchaseHeader.Validate("Posting Date", PostingDate);

        if Job."External Document No." <> '' then
            PurchaseHeader.Validate("Vendor Invoice No.", Job."External Document No.");

        PurchaseHeader."Your Reference" := Job."Your Reference";
        if PurchaseHeader.Modify(true) then
            exit(true);
    end;

    local procedure CreateFirstPurchaseLine(var JobPlanningLine: Record "Job Planning Line"; PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine.Type := PurchaseLine.Type::" ";
        PurchaseLine.Description := 'Job No.: ' + JobPlanningLine."Job No." + '; Job Task No.: ' + JobPlanningLine."Job Task No." + '; Resource No.: ' + JobPlanningLine."No.";
        PurchaseLine."Line No." := GetNextLineNo(PurchaseLine);
        PurchaseLine.Insert(true);
    end;

    procedure UpdatePurchaseLine(var JobPlanningLine: Record "Job Planning Line")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", JobPlanningLine."Update Purchase Order");
        PurchaseLine.SetRange("Job Resource No.", JobPlanningLine."No.");
        PurchaseLine.SetRange("Job No.", JobPlanningLine."Job No.");
        IF PurchaseLine.FindFirst() then BEGIN
            //Message('%1..%2', PurchaseLine."Qty. to Receive", JobPlanningLine."Qty. to Transfer to Purch. Inv");
            PurchaseLine."Qty. to Receive" += JobPlanningLine."Qty. to Transfer to Purch. Inv";
            PurchaseLine.Validate("Qty. to Receive");
            PurchaseLine.Modify();
            JobPlanningLine."Qty. Transferred to Purch. Inv" += JobPlanningLine."Qty. to Transfer to Purch. Inv";
            JobPlanningLine."Qty. to Transfer to Purch. Inv" := JobPlanningLine.Quantity - JobPlanningLine."Qty. Transferred to Purch. Inv";
            JobPlanningLine.Modify();
        End;
    end;

    procedure CreatePurchaseLine(var JobPlanningLine: Record "Job Planning Line"; PurchaseHeader: Record "Purchase Header"; Job: Record Job; JobPostingGroup: Record "Job Posting Group")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(PurchaseLine);
        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.Validate("No.", JobPostingGroup."Sub-Contracting Accrual cost");
        PurchaseLine.Validate("Gen. Prod. Posting Group", JobPlanningLine."Gen. Prod. Posting Group");
        PurchaseLine.Validate("Location Code", JobPlanningLine."Location Code");
        PurchaseLine.Validate("Variant Code", JobPlanningLine."Variant Code");
        PurchaseLine.Validate("Job Resource No.", JobPlanningLine."No.");
        PurchaseLine.Validate("Job No.", JobPlanningLine."Job No.");
        if PurchaseLine.Type <> PurchaseLine.Type::" " then begin
            PurchaseLine.Validate("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
            PurchaseLine.Validate(Quantity, JobPlanningLine."Qty. to Transfer to Purch. Inv");
            if JobPlanningLine."Currency Code" <> '' then
                PurchaseLine.VAlidate("Currency Code", JobPlanningLine."Currency Code");
            PurchaseLine.Validate("Direct Unit Cost", JobPlanningLine."Unit Cost");
            PurchaseLine.Validate("Line Discount %", JobPlanningLine."Line Discount %");
            PurchaseLine."Inv. Discount Amount" := 0;
            PurchaseLine."Inv. Disc. Amount to Invoice" := 0;
            PurchaseLine.UpdateAmounts();
        end;
        PurchaseLine."Line No." := GetNextLineNo(PurchaseLine);
        PurchaseLine.Insert(true);

        PurchaseLine.Validate("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
        PurchaseLine.Validate("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
        PurchaseLine.Modify();

        JobPlanningLine."Subcon. Invoice No." := PurchaseLine."Document No.";
        JobPlanningLine."Subcon. Invoice Line No." := PurchaseLine."Line No.";
        JobPlanningLine."Qty. Transferred to Purch. Inv" += JobPlanningLine."Qty. to Transfer to Purch. Inv";
        JobPlanningLine."Qty. to Transfer to Purch. Inv" := JobPlanningLine.Quantity - JobPlanningLine."Qty. Transferred to Purch. Inv";
        JobPlanningLine.Modify();
        Commit();
    end;

    local procedure GetNextLineNo(var PurchLine: Record "Purchase Line"): Integer
    var
        NextLineNo: Integer;
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchLine."Document Type");
        PurchaseLine.SetRange("Document No.", PurchLine."Document No.");
        NextLineNo := 10000;
        if PurchaseLine.FindLast() then
            NextLineNo := PurchaseLine."Line No." + 10000;
        exit(NextLineNo);
    end;

    procedure ShowCreatedPurchaseInvoices(JobPlanningLine: Record "Job Planning Line")
    var
        PurchaseHeader: Record "Purchase Header";
        JobPlanningLine1: Record "Job Planning Line";
        PrevInvoiceNo: Code[20];
    begin
        JobPlanningLine1.Reset();
        JobPlanningLine1.SetCurrentKey("Subcon. Invoice No.", "Subcon. Invoice Line No.");
        JobPlanningLine1.SetRange("Job No.", JobPlanningLine."Job No.");
        //JobPlanningLine1.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        //JobPlanningLine1.SetFilter("Subcon. Invoice No.", '<>%1', '');
        if JobPlanningLine1.FindSet() then begin
            repeat
                if PrevInvoiceNo <> JobPlanningLine1."Subcon. Invoice No." then begin
                    PrevInvoiceNo := JobPlanningLine1."Subcon. Invoice No.";
                    if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PrevInvoiceNo) then
                        PurchaseHeader.Mark(true);
                end;
            until JobPlanningLine1.Next() = 0;
            PurchaseHeader.MarkedOnly(true);
            Page.RunModal(0, PurchaseHeader);
        end;
    end;

}