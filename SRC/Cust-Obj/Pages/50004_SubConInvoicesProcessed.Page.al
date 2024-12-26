page 50004 "Sub-Con Invoices Processed"
{
    ApplicationArea = All;
    Caption = 'Sub-Con Invoice Processed';
    PageType = List;
    SourceTable = "Sub-Con Invoice Processed";
    UsageCategory = History;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ToolTip = 'Specifies the value of the Job Task No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ToolTip = 'Specifies the value of the Line Type field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Qty. Transferred to Purch. Inv"; Rec."Qty. Transferred to Purch. Inv")
                {
                    ToolTip = 'Specifies the value of the Qty. Transferred to Purch. Inv field.';
                }
                field("Qty. Purchase Invoiced"; Rec."Qty. Purchase Invoiced")
                {
                    ToolTip = 'Specifies the value of the Qty. Purchase Invoiced field.';
                }
                field("Remaining Qty.";Rec."Remaining Qty.")
                {
                    
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Job Task Line No."; Rec."Job Task Line No.")
                {
                    ToolTip = 'Specifies the value of the Job Task Line No. field.';
                }
                field("Sub-Con Invoice No."; Rec."Sub-Con Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Sub-Con Invoice No. field.';
                }
                field("Sub-Con Invoice Line No."; Rec."Sub-Con Invoice Line No.")
                {
                    ToolTip = 'Specifies the value of the Sub-Con Invoice Line No. field.';
                }
            }
        }
    }
}
