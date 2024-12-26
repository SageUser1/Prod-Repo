tableextension 50000 GLATblExt extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Account Category CompQ"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Acc. Catg. CompQ";
            ToolTip = 'Information about account category of CompQ.';
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



}