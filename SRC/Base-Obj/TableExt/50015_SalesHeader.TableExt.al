tableextension 50015 SalhDrTabExt extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Customer PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Sub. Contract. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Task Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Billing From Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Billing To Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Project Class"; enum "Project Class")
        {
            DataClassification = CustomerContent;
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