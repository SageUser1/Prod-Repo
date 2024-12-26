tableextension 50005 "Job WIP Entry Ext" extends "Job WIP Entry"
{
    fields
    {
        field(50000; "Vendor No. B2B"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Job Task No. B2B"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Custom WIP Entry"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Resource No. B2B"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50004; "Job Planning Line No. B2B"; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
}