table 50001 "Vendor Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = 50002;
    DrillDownPageId = 50002;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Sub-Con Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Description, "Sub-Con Vendor")
        {
        }

    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}