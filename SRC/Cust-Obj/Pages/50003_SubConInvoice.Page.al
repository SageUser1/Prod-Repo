page 50003 "Sub-Con Invoices"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Sub-Con Invoice";
    Caption = 'Sub-Con Invoice';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit() then
                            CurrPage.Update(false);
                    end;
                }
                field(VendorNo; VendorNo)
                {
                    ApplicationArea = all;
                    Caption = 'Vendor No.';
                    TableRelation = Vendor;

                    trigger OnValidate()
                    var
                        Vendor: Record Vendor;
                        SubConInvoice: Record "Sub-Con Invoice";
                    begin
                        if Vendor.Get(VendorNo) then
                            VendorName := Vendor.Name;
                        SubConInvoice.Reset();
                        if SubConInvoice.FindSet() then
                            SubConInvoice.DeleteAll();
                    end;
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = all;
                    Caption = 'Vendor Name';
                    Editable = false;
                }
                field(VendorInvNo; VendorInvNo)
                {
                    ApplicationArea = all;
                    Caption = 'Vendor Invoice No.';

                }
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date';
                }
                field(MonthVar; MonthVar)
                {
                    ApplicationArea = all;
                    Caption = 'Month';
                }
                field(YearVar; YearVar)
                {
                    ApplicationArea = all;
                    Caption = 'Year';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DateGrec: Record Date;
                    begin
                        DateGrec.Reset();
                        DateGrec.SetRange("Period Type", DateGrec."Period Type"::Year);
                        DateGrec.SetFilter("Period No.", '>%1', 2000);
                        if DateGrec.FindSet() then
                            if page.RunModal(page::"Yearly Lookup", DateGrec) = Action::LookupOK then
                                YearVar := DateGrec."Period No.";
                    end;
                }
            }

            repeater(Control1)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty. Transfer to Purch. Invoice"; Rec."Qty. Transfer to Purch. Inv")
                {
                    ApplicationArea = all;
                }
                field("Qty. Transferred to Purch. Inv"; Rec."Qty. Transferred to Purch. Inv")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty. Purchase Invoiced"; Rec."Qty. Purchase Invoiced")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetTaskLines)
            {
                ApplicationArea = All;
                Caption = 'Get Task Lines';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ErrTxt: Label 'Vendor No. must have a value.';
                    ErrTxt2: Label 'Document No. must have a value.';
                begin
                    if VendorNo = '' then
                        Error(ErrTxt);
                    if DocumentNo = '' then
                        Error(ErrTxt2);
                    GetJobPlanningLines();
                end;
            }
            action(CreatePurchaseInvoice)
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Invoice';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ErrTxt: Label 'There is no lines for creating invoices.';
                begin
                    Rec.CreatePurchInvoice();
                    RefreshVariables();
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        SubConInvoice: Record "Sub-Con Invoice";
    begin
        SubConInvoice.Reset();
        SubConInvoice.SetRange("Job No.", '');
        if SubConInvoice.FindFirst() then
            SubConInvoice.Delete();
        SubConInvoice.Reset();
        if SubConInvoice.FindFirst() then begin
            DocumentNo := SubConInvoice."Document No.";
            VendorNo := SubConInvoice."Vendor No.";
            VendorName := SubConInvoice."Vendor Name";
            VendorInvNo := SubConInvoice."Vendor Invoice No.";
            PostingDate := SubConInvoice."Posting Date";
            MonthVar := SubConInvoice.Month;
            YearVar := SubConInvoice.Year;
        end;
    end;


    var
        DocumentNo: Code[20];
        VendorNo: Code[20];
        VendorName: Text;
        VendorInvNo: Code[20];
        PostingDate: Date;
        MonthVar: Enum "Recurrence - Month";
        YearVar: Integer;
        NoSeries: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JobSetup: Record "Jobs Setup";

    local procedure AssistEdit() Result: Boolean
    begin
        JobSetup.Get();
        JobSetup.TestField("Sub-Con Invoice Nos");
        if NoSeriesMgt.SelectSeries(JobSetup."Sub-Con Invoice Nos", '', NoSeries) then begin
            NoSeriesMgt.SetSeries(DocumentNo);
            exit(true);
        end;
    end;

    local procedure RefreshVariables()
    var
        SubConInvoice: Record "Sub-Con Invoice";
    begin
        SubConInvoice.Reset();
        if SubConInvoice.FindFirst() then begin
            DocumentNo := SubConInvoice."Document No.";
            VendorNo := SubConInvoice."Vendor No.";
            VendorName := SubConInvoice."Vendor Name";
            VendorInvNo := SubConInvoice."Vendor Invoice No.";
            PostingDate := SubConInvoice."Posting Date";
            MonthVar := SubConInvoice.Month;
            YearVar := SubConInvoice.Year;
        end else begin
            Clear(DocumentNo);
            Clear(VendorNo);
            Clear(VendorName);
            Clear(VendorInvNo);
            Clear(PostingDate);
            Clear(MonthVar);
            Clear(YearVar);
        end;
    end;

    local procedure GetJobPlanningLines()
    var
        JobPlanningLine: Record "Job Planning Line";
        Resource: Record Resource;
        SubConInvoice: Record "Sub-Con Invoice";
        LineNo: Integer;
        ErrTxt: Label 'There are no job planning lines available with these filters.';
    begin
        SubConInvoice.Reset();
        SubConInvoice.SetRange("Vendor No.", VendorNo);
        if SubConInvoice.FindSet() then
            SubConInvoice.DeleteAll();

        Clear(SubConInvoice);
        LineNo := 10000;

        JobPlanningLine.Reset();
        JobPlanningLine.SetCurrentKey("Job No.", "Job Task No.", "Line No.");
        JobPlanningLine.SetFilter("Line Type", '<>%1', JobPlanningLine."Line Type"::Budget);
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SetFilter("No.", '<>%1', '');
        if JobPlanningLine.FindSet() then begin
            repeat
                if JobPlanningLine.Quantity - JobPlanningLine."Qty. Purchase Invoiced" <> 0 then
                    if (Resource.Get(JobPlanningLine."No.")) and (Resource."Sub-Contracting Resource") then
                        if Resource."Sub-Con. Resource Vendor" = VendorNo then
                            JobPlanningLine.Mark(true);
            until JobPlanningLine.Next() = 0;
            JobPlanningLine.MarkedOnly(true);
            if JobPlanningLine.FindSet() then begin
                repeat
                    SubConInvoice.Init();
                    SubConInvoice."Document No." := DocumentNo;
                    SubConInvoice."Line No." := LineNo;
                    SubConInvoice."Vendor No." := VendorNo;
                    SubConInvoice."Vendor Name" := VendorName;
                    SubConInvoice."Vendor Invoice No." := VendorInvNo;
                    SubConInvoice."Posting Date" := PostingDate;
                    SubConInvoice.Month := MonthVar;
                    SubConInvoice.Year := YearVar;
                    SubConInvoice."Job No." := JobPlanningLine."Job No.";
                    SubConInvoice."Job Task No." := JobPlanningLine."Job Task No.";
                    SubConInvoice."Job Task Line No." := JobPlanningLine."Line No.";
                    SubConInvoice.Description := JobPlanningLine.Description;
                    SubConInvoice."Line Type" := JobPlanningLine."Line Type";
                    SubConInvoice.Type := JobPlanningLine.Type;
                    SubConInvoice."No." := JobPlanningLine."No.";
                    SubConInvoice.Quantity := JobPlanningLine.Quantity;
                    SubConInvoice."Unit Cost" := JobPlanningLine."Unit Cost";
                    SubConInvoice."Line Amount" := JobPlanningLine."Total Cost";
                    SubConInvoice."Qty. Transferred to Purch. Inv" := JobPlanningLine."Qty. Transferred to Purch. Inv";
                    SubConInvoice."Qty. Purchase Invoiced" := JobPlanningLine."Qty. Purchase Invoiced";
                    SubConInvoice."Remaining Qty." := SubConInvoice.Quantity - SubConInvoice."Qty. Purchase Invoiced";
                    SubConInvoice.Insert();
                    LineNo += 10000;
                until JobPlanningLine.Next() = 0;
            end else
                Error(ErrTxt);
        end;
    end;

}