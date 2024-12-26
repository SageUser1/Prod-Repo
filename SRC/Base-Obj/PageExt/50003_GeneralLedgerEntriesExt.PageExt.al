pageextension 50003 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Vendor No. B2B"; Rec."Vendor No. B2B")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Vendor No.';
            }
            field("Invoice No."; Rec."Invoice No. B2B")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Invoice No.';
            }
            field("Job Task No. B2B"; Rec."Job Task No. B2B")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Job Task No.';
            }
        }
    }
}