pageextension 50009 "Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Charge Code"; Rec."Charge Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Job No.")
        {
            Visible = true;
            Editable = true;
        }
        modify("Job Task No.")
        {
            Visible = true;
            Editable = true;
        }

        addafter("Job Task No.")
        {

            field("Job Name"; Rec."Job Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Name field.';
            }
        }
    }
}