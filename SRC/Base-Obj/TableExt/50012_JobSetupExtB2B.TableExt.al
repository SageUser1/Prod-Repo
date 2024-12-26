tableextension 50012 "Job Setup Ext" extends "Jobs Setup"
{
    fields
    {
        field(50000; "Sub-Con Invoice Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
    }
}