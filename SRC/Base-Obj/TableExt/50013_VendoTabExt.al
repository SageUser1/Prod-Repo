tableextension 50013 VendTabExt extends Vendor
{
    fields
    {
        // Add changes to table fields 
        field(50000; "Vendor Type"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Type";
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