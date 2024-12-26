tableextension 50014 UserSetup extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Gen Led Entries Email"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Aged Acc. Payable Email"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Project Manager"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Show All Resource"; Boolean)
        {
            DataClassification = ToBeClassified;
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