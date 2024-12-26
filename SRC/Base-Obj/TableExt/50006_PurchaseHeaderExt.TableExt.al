tableextension 50006 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50000; "Memo"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50001; "FOB"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Ship Via"; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }
}