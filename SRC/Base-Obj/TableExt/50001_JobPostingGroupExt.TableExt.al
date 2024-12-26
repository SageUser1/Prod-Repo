tableextension 50001 "Job Posting Group Ext" extends "Job Posting Group"
{
    fields
    {
        field(50000; "Sub-Contracting Cost"; Code[20])
        {
            Caption = 'Sub-Contracting Cost';
            TableRelation = "G/L Account";
        }
        field(50001; "Sub-Contracting Accrual cost"; Code[20])
        {
            Caption = 'Sub-Contracting Accrual Cost';
            TableRelation = "G/L Account";
        }
    }
}