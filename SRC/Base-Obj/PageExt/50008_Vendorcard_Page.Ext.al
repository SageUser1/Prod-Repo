pageextension 50008 VendorcardExt extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Vendor Type"; Rec."Vendor Type")
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