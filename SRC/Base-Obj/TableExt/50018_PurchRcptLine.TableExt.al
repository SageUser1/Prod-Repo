tableextension 50018 PurchRcptLine extends "Purch. Rcpt. Line"
{
    fields
    {
        // Add changes to table fields here
        field(50006; "Job No. Compq"; code[20])
        {
            Editable = false;
            Caption = 'Project No.';
            TableRelation = Job;
        }
        field(50007; "Job Task No. Compq"; code[20])
        {
            Caption = 'Project Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No. Compq"));
        }
        field(50008; "Job Line No. Compq"; Integer)
        {
            Caption = 'Line No.';

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