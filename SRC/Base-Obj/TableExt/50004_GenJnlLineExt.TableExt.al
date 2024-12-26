tableextension 50004 "Gen Jnl Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Vendor No. B2B"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Invoice No. B2B"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Job Task No. B2B"; Code[20])
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