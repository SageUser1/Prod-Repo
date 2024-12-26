pageextension 50026 SalesInvPagExt extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document Date")
        {
            field("Sub. Contract. No."; Rec."Sub. Contract. No.")
            {
                ApplicationArea = all;
            }
            field("Task Order No."; Rec."Task Order No.")
            {
                ApplicationArea = all;
            }
            field("Billing From Period"; Rec."Billing From Period")
            {
                ApplicationArea = all;
            }
            field("Billing To Period"; Rec."Billing To Period")
            {
                ApplicationArea = all;
            }
            field("Project Class"; Rec."Project Class")
            {
                ApplicationArea = all;
                Caption = 'Project Classification';
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