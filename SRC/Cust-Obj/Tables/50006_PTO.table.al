table 50006 "PTO Details"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Year; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; Month; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Resource No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Resource;
            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                IF Resource.GET("Resource No.") then
                    "Resource Name" := Resource.Name
                else
                    Clear("Resource Name");
            end;
        }
        field(4; "Resource Name"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Leave Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;

        }
        field(6; "Opening Balance"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Current Year Balance"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Available Leaves" := "Opening Balance" + "Current Year Balance" - "Current. Utilized";
            end;

        }
        field(8; Utilized; Integer)
        {
            DataClassification = ToBeClassified;

        }

        field(9; "Available Leaves"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(10; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                IF Employee.GET("Employee No.") then
                    Validate("Resource No.", Employee."Resource No.")
                else
                    clear("Resource No.");
            end;
        }
        field(11; "Current. Utilized"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Employee Absence".Quantity where(Month = field(Month), Year = field(Year), "Cause of Absence Code" = field("Leave Type")));
        }
    }

    keys
    {
        key(PK; Year, Month, "Employee No.", "Leave Type")
        {
            Clustered = true;
        }
    }

    var
        Itemd: record item;

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