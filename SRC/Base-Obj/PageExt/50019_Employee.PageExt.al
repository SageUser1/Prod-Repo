pageextension 50019 EmployeeCardExt extends "Employee Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Company E-Mail")
        {
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(History)
        {
            action("Base Calender")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                image = ShowList;
                RunObject = page "Base Calendar List";
            }
            action("Leave Info")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                image = ShowList;
                RunObject = page "Leave Management";
                RunPageLink = "Employee No." = field("No.");
            }
            action("Salary Details")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                image = ShowList;
                RunObject = page "Employee Salary Details";
                RunPageLink = "Employee Code" = field("No.");
            }
        }
    }

    var
        myInt: Integer;
}