tableextension 50010 "Sales Line Ext" extends "Sales Line"
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
        field(50001; "Job Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = ' Job Name';
        }
    }
}