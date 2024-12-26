tableextension 50016 EmployAbseTabExt extends "Employee Absence"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Year; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Month; Integer)
        {
            DataClassification = ToBeClassified;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                Year := Date2DMY(rec."From Date", 3);
                Month := Date2DMY(rec."From Date", 2);
            end;
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

    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin

    end;
}