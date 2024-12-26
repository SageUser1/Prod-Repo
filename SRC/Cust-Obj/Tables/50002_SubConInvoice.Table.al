table 50002 "Sub-Con Invoice"
{
    DataClassification = CustomerContent;
    Caption = 'Sub-Con Invoice';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(3; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Invoice No."; Code[30])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; Month; Enum "Recurrence - Month")
        {
            Caption = 'Month';
            DataClassification = CustomerContent;
        }
        field(7; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;

        }
        field(8; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Job;
        }
        field(9; "Job Task No."; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Line Type"; Enum "Job Planning Line Line Type")
        {
            DataClassification = CustomerContent;
        }
        field(12; Type; Enum "Job Planning Line Type")
        {
            Caption = 'Type';
        }
        field(13; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource;
        }
        field(14; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Qty. Transfer to Purch. Inv"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ErrTxt1: Label 'Qty. to Transfer to Purch. Invoice must be less than or equal to %1.';
            begin
                if "Qty. Transfer to Purch. Inv" > Quantity - "Qty. Transferred to Purch. Inv" then
                    Error(ErrTxt1, Format(Quantity - "Qty. Transferred to Purch. Inv"));
            end;
        }
        field(18; "Qty. Transferred to Purch. Inv"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Qty. Purchase Invoiced"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(20; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "No. Series"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(22; "Job Task Line No."; Integer)
        {
            TableRelation = "Job Planning Line"."Line No." where("Job No." = field("Job No."), "Job Task No." = field("Job Task No."));
        }
        field(23; "Sub-Con Invoice No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Invoice));
        }
        field(24; "Sub-Con Invoice Line No."; Integer)
        {
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Invoice), "Document No." = field("Sub-Con Invoice No."));
        }
        field(25; "Remaining Qty."; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        PostedEntryNo: Integer;

    procedure CreatePurchInvoice()
    var
        Job: Record Job;
        SubConInvoice2: Record "Sub-Con Invoice";
        PurchaseHeader: Record "Purchase Header";
        SubConInvoice: Record "Sub-Con Invoice";
        SubConInvProcessed: Record "Sub-Con Invoice Processed";
        PrevResourceNo: Code[20];
        PurchLine: Record "Purchase Line";
        Resource: Record Resource;
        JobPostingGroup: Record "Job Posting Group";
        InvoicesCreated: Boolean;
        Err001: Label 'No lines to create purchase invoice.';
        Err002: Label 'Please Post the existing invoice - %1 which is already created for resorce - %2.';
        SuccessText: Label 'Purchase Invoices created successfully. Do you want to navigate to those invoices?';
    begin
        InvoicesCreated := false;
        SubConInvoice.Reset();
        SubConInvoice.SetCurrentKey("No.");
        SubConInvoice.SetFilter("Qty. Transfer to Purch. Inv", '>%1', 0);
        if SubConInvoice.FindSet() then begin
            Job.Get(SubConInvoice."Job No.");
            if Resource.Get(SubConInvoice."No.") then
                if CreatePurchaseHeader(Job, WorkDate(), SubConInvoice, PurchaseHeader, Resource) then begin
                    InvoicesCreated := true;
                    JobPostingGroup.Get(Job."Job Posting Group");
                    JobPostingGroup.TestField("Sub-Contracting Accrual cost");
                    repeat
                        if PrevResourceNo <> SubConInvoice."No." then begin
                            PrevResourceNo := SubConInvoice."No.";
                            CreateFirstPurchaseLine(SubConInvoice, PurchaseHeader);
                        end;
                        CreatePurchaseLine(SubConInvoice, PurchaseHeader, Job, JobPostingGroup);
                    until SubConInvoice.Next() = 0;
                end;
            if InvoicesCreated then begin
                if Confirm(SuccessText, false) then
                    ShowCreatedPurchaseInvoices(PurchaseHeader)
                else
                    exit;
            end else
                Error(Err001);
        end else
            Error(Err001);
    end;

    local procedure CreatePurchaseHeader(Job: Record Job; PostingDate: Date; SubConInvoice: Record "Sub-Con Invoice"; var PurchaseHeader: Record "Purchase Header"; Resource: Record Resource): Boolean
    var
        PurchaseSetup: Record "Purchases & Payables Setup";
    begin
        Clear(PurchaseHeader);
        PurchaseSetup.Get();
        PurchaseHeader.Init();
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseSetup.TestField("Invoice Nos.");
        PurchaseHeader."Posting Date" := PostingDate;
        PurchaseHeader.Insert(true);

        PurchaseHeader.SetHideValidationDialog(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", SubConInvoice."Vendor No.");
        PurchaseHeader.Validate("Pay-to Vendor No.", SubConInvoice."Vendor No.");

        if SubConInvoice."Vendor Invoice No." <> '' then
            PurchaseHeader.Validate("Vendor Invoice No.", SubConInvoice."Vendor Invoice No.");

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

        PurchaseHeader.Validate("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
        PurchaseHeader.Validate("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");

        PurchaseHeader."Your Reference" := Job."Your Reference";
        if PurchaseHeader.Modify(true) then
            exit(true);
    end;

    local procedure CreateFirstPurchaseLine(var SubConInvoice: Record "Sub-Con Invoice"; PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine.Type := PurchaseLine.Type::" ";
        PurchaseLine.Description := 'Resource No.: ' + SubConInvoice."No.";
        PurchaseLine."Line No." := GetNextLineNo(PurchaseLine);
        PurchaseLine.Insert(true);
    end;

    procedure CreatePurchaseLine(var SubConInvoice: Record "Sub-Con Invoice"; PurchaseHeader: Record "Purchase Header"; Job: Record Job; JobPostingGroup: Record "Job Posting Group")
    var
        PurchaseLine: Record "Purchase Line";
        JobPlanningLine: Record "Job Planning Line";
        ErrTxt: Label 'Job Planning Line is not found.';
        SubConInvProcessed: Record "Sub-Con Invoice Processed";

    begin
        if not JobPlanningLine.Get(SubConInvoice."Job No.", SubConInvoice."Job Task No.", SubConInvoice."Job Task Line No.") then
            Error(ErrTxt);
        Clear(PurchaseLine);
        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.Validate("No.", JobPostingGroup."Sub-Contracting Accrual cost");
        PurchaseLine.Validate("Gen. Prod. Posting Group", JobPlanningLine."Gen. Prod. Posting Group");
        PurchaseLine.Validate("Location Code", JobPlanningLine."Location Code");
        PurchaseLine.Validate("Variant Code", JobPlanningLine."Variant Code");

        if PurchaseLine.Type <> PurchaseLine.Type::" " then begin
            PurchaseLine.Validate("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
            PurchaseLine.Validate(Quantity, SubConInvoice."Qty. Transfer to Purch. Inv");
            if JobPlanningLine."Currency Code" <> '' then
                PurchaseLine.VAlidate("Currency Code", JobPlanningLine."Currency Code");
            PurchaseLine.Validate("Direct Unit Cost", SubConInvoice."Unit Cost");
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

        SubConInvoice."Qty. Transferred to Purch. Inv" += SubConInvoice."Qty. Transfer to Purch. Inv";
        SubConInvoice."Qty. Transfer to Purch. Inv" := 0;
        SubConInvoice."Sub-Con Invoice No." := PurchaseLine."Document No.";
        SubConInvoice."Sub-Con Invoice Line No." := PurchaseLine."Line No.";
        SubConInvoice.Modify();

        SubConInvProcessed.Init();
        SubConInvProcessed.TransferFields(SubConInvoice);
        SubConInvProcessed."Sub-Con Invoice No." := PurchaseLine."Document No.";
        SubConInvProcessed."Sub-Con Invoice Line No." := PurchaseLine."Line No.";
        SubConInvProcessed."Qty. Transferred to Purch. Inv" += SubConInvoice."Qty. Transfer to Purch. Inv";
        SubConInvProcessed.Insert();

        JobPlanningLine."Qty. Transferred to Purch. Inv" := SubConInvProcessed."Qty. Transferred to Purch. Inv";
        JobPlanningLine."Subcon. Invoice No." := PurchaseLine."Document No.";
        JobPlanningLine."Subcon. Invoice Line No." := PurchaseLine."Line No.";
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

    procedure ShowCreatedPurchaseInvoices(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseHeader2: Record "Purchase Header";
    begin
        PurchaseHeader2.Reset();
        PurchaseHeader2.SetRange("Document Type", PurchaseHeader2."Document Type"::Invoice);
        PurchaseHeader2.SetRange("No.", PurchaseHeader."No.");
        if PurchaseHeader2.FindFirst() then
            Page.RunModal(Page::"Purchase Invoice", PurchaseHeader);
    end;

}