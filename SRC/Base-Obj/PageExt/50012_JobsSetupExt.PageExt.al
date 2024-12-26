pageextension 50012 "Jobs Setup Ext" extends "Jobs Setup"
{
    layout
    {
        addlast(Numbering)
        {
            field("Sub-Con Invoice Nos"; Rec."Sub-Con Invoice Nos")
            {
                ApplicationArea = All;
            }
        }
    }
}