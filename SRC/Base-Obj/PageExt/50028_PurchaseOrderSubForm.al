pageextension 50028 PurchOrdSubformExt extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Job Resource No."; Rec."Job Resource No.")
            {
                ApplicationArea = all;
            }
            field("Job Res. Name"; Rec."Job Res. Name")
            {
                ApplicationArea = all;
            }
            field("Job Name"; Rec."Job Name")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Job Task No.")
        {
            field("Job No. Compq"; Rec."Job No. Compq")
            {
                ApplicationArea = all;
            }
            field("Job Task No. Compq"; Rec."Job Task No. Compq")
            {
                ApplicationArea = all;
            }
            field("Job Line No. Compq"; Rec."Job Line No. Compq")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}