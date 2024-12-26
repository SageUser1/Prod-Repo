pageextension 50000 GLACardpageExt extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Account Category")
        {
            field("Account Category CompQ"; Rec."Account Category CompQ")
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