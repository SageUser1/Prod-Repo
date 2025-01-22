page 50014 "Employee Salary Details"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employee Salary Details";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                }
                field("Semi Monthly Salary"; Rec."Semi Monthly Salary")
                {
                    ApplicationArea = all;
                }
                field("Monthly Salary"; Rec."Monthly Salary")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}