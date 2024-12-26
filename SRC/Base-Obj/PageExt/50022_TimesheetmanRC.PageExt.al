pageextension 50022 TimesheetRC extends "Job Project Manager RC"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addbefore("Manager Time Sheet by Job")
        {
            action("Create Time Sheets 2")
            {
                AccessByPermission = TableData "Time Sheet Header" = IMD;
                ApplicationArea = Jobs;
                Caption = 'Create Time Sheets - 15D';
                Image = JobTimeSheet;
                RunObject = Report "Create Time Sheets - 15 Days";
                ToolTip = 'As the time sheet administrator, create time sheets for resources that have the Use Time Sheet check box selected on the resource card. Afterwards, view the time sheets that you have created in the Time Sheets window.';
            }
            action("Manage Time Sheets 2")
            {
                AccessByPermission = TableData "Time Sheet Header" = IMD;
                ApplicationArea = Jobs;
                Caption = 'Manager Time Sheets - 15D';
                Image = JobTimeSheet;
                RunObject = Page "Manager Time Sheet List - 15D";
                ToolTip = 'Approve or reject your resources'' time sheet entries in a window that contains lines for all time sheets that resources have submitted for review.';
            }
        }
        modify("Create Time Sheets")
        {
            Visible = false;
        }
        modify("Manage Time Sheets")
        {
            Visible = false;
        }
    }

    var
        myInt: Integer;
}