table 50008 "Employee Salary Details"
{
    DataClassification = ToBeClassified;
    LookupPageId = 50014;
    DrillDownPageId = 50014;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            trigger OnValidate()
            var
                Empl: Record Employee;
            begin
                IF Empl.get("Employee Code") then
                    Name := Empl."First Name"
                else
                    Clear(name);
            end;

        }
        field(2; Name; text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; Year; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Semi Monthly Salary"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Monthly Salary"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Employee Code", Year)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Employee Code", Year)
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