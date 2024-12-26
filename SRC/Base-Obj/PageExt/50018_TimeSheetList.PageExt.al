pageextension 50018 TimeSheetExt extends "Time Sheet List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addbefore("&Time Sheet")
        {
            action(OpenTimeSheet)
            {
                ApplicationArea = Jobs;
                Scope = Repeater;
                Caption = 'Open Time Sheet Card-15D';
                Image = OpenWorksheet;
                RunObject = page "Time Sheet Card - 15D";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Open Time Sheet Card for the record.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
            }
        }
    }

    var
        myInt: Integer;
}