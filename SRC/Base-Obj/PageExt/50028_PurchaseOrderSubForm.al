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
            field("Job No"; Rec."Job No.")
            {
                ApplicationArea = all;
            }
            field("Job Name"; Rec."Job Name")
            {
                ApplicationArea = all;
            }
            field("Job TaskNo."; Rec."Job Task No.")
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