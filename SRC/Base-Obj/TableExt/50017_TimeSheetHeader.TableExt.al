tableextension 50017 TimesheetheaderTabExt extends "Time Sheet Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Resource Name 2"; text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource Name.';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}