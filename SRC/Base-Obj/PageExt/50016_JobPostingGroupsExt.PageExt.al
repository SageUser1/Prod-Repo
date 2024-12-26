pageextension 50016 "Job Posting Groups ext" extends "Job Posting Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("Sub-Contracting Cost"; Rec."Sub-Contracting Cost")
            {
                ApplicationArea = all;
            }
            field("Sub-Contracting Accrual cost"; Rec."Sub-Contracting Accrual cost")
            {
                ApplicationArea = all;
            }
        }
    }
}