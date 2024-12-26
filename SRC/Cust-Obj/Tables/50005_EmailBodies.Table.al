table 50005 "Email Bodies"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Type; enum "Email Bosy Type")
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Email Editor"; Text[250])
        {
            Caption = 'Message';
            ToolTip = 'Specifies the content of the email.';
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
        // Add changes to field groups here
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