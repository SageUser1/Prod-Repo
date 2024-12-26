reportextension 50001 CreateTimeSheetRep extends "Create Time Sheets"
{
    dataset
    {
        // Add changes to dataitems and columns here
    }

    requestpage
    {
        // Add changes to the requestpage here
        trigger OnOpenPage()
        var
            myInt: Integer;
        begin
            Error('Please use "Create Time Sheets - 15 D Report" to create time sheets.');
        end;
    }

}