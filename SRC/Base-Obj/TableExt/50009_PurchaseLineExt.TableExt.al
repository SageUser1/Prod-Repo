tableextension 50009 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("Job No.")
        {
            trigger OnAfterValidate()
            var
                jobGrec: Record Job;
            begin
                if jobGrec.get("Job No.") then
                    "Job Name" := jobGrec.Description;

            end;

        }
        field(50000; "Charge Code"; Code[50])
        {
            DataClassification = CustomerContent;
        }

        field(50003; "Job Name"; Text[100])
        {
            Caption = 'Job Name';
            DataClassification = CustomerContent;
        }
        field(50004; "Job Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource;
            trigger OnValidate()
            var
                Resourc: Record Resource;
            begin
                IF Resourc.GET("Job Resource No.") then
                    "Job Res. Name" := Resourc.Name
                else
                    Clear("Job Res. Name");
            end;
        }
        field(50005; "Job Res. Name"; text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

    }

    var

}