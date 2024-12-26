pageextension 50021 MngTimesheetlistExt extends "Manager Time Sheet List"
{

    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Error('Please use "Manager Time sheet - 15 D page" to view Time sheets.');
    end;
}