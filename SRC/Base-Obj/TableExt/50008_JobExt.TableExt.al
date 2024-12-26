tableextension 50008 "Job Ext" extends Job
{
    fields
    {
        field(50000; "Charge Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Ceipal Job ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Billable Client"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(50004; "Contract No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Total (Cost+Fee)" := Cost + fee;
            end;
        }
        field(50006; "Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Total (Cost+Fee)" := Cost + fee;
            end;
        }
        field(50007; "Total (Cost+Fee)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Owing Organisation"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Owing Organisation";
        }
        field(50009; "Prime Contact No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Project Class"; enum "Project Class")
        {
            DataClassification = CustomerContent;
        }
        field(50011; "Project type"; enum "Project Type")
        {
            DataClassification = CustomerContent;
        }
        field(50012; "Contract Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Funded Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Gen & Adm %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Fringe %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Over Head %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

}