pageextension 50010 "50012 JobList Ext" extends "Job List"
{
    layout
    {
        addafter("Bill-to Customer No.")
        {

            field("Bill-to Name"; Rec."Bill-to Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the customer who pays for the job.';
            }
            field("Charge Code"; Rec."Charge Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Charge Code field.';
            }


        }
    }



}
