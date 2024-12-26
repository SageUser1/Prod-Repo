tableextension 50007 "Resource Ext" extends Resource
{
    fields
    {
        field(50000; "Sub-Contracting Resource"; Boolean)
        {
            Caption = 'Sub-Contracting Resource';

            trigger OnValidate()
            begin
                if not "Sub-Contracting Resource" then
                    Validate("Sub-Con. Resource Vendor", '');
            end;
        }
        field(50001; "Sub-Con. Resource Vendor"; Code[20])
        {
            Caption = 'Sub-Contracting Resource Vendor';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Sub-Con. Resource Vendor") then
                    "Sub-Con. Resource Vendor Name" := Vendor.Name
                else
                    "Sub-Con. Resource Vendor Name" := '';
            end;
        }
        field(50002; "Sub-Con. Resource Vendor Name"; Text[100])
        {
            Caption = 'Sub-Con Resource Vendor Name';
            Editable = false;
        }
        field(50003; Gender; Option)
        {
            Caption = 'Gender';
            OptionMembers = Male,Female;
            OptionCaption = 'Male,Female';
        }
        field(50004; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(50005; "E-Mail"; Text[100])
        {
            Caption = 'E-Mail';
        }
        field(50006; "Ceipal Employee ID"; Code[30])
        {
            Caption = 'Ceipal Employee ID';
        }
        field(50007; "Resource Category"; Code[20])
        {
            Caption = 'Resource Category';
            TableRelation = "Resource Category";
        }

    }
}