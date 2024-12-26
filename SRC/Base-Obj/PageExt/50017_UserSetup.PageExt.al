pageextension 50017 Usersetup extends "User Setup"
{
    layout
    {
        addafter(Email)
        {
            field("Finance Email"; Rec."Gen Led Entries Email")
            {
                ApplicationArea = all;
            }
            field("Aged Acc. Payable Email"; Rec."Aged Acc. Payable Email")
            {
                ApplicationArea = all;
            }
            field("Project Manager"; rec."Project Manager")
            {
                ApplicationArea = all;
            }
            field("Show All Resource"; Rec."Show All Resource")
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