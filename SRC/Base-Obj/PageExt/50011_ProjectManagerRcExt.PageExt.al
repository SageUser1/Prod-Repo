pageextension 50011 "Project Manager RC Ext" extends "Project Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {

        addafter("Job Create Sales Invoice")
        {
            action("Sub-Con Invoice")
            {
                ApplicationArea = Jobs;
                Caption = 'Sub-Con Invoices';
                RunObject = page "Sub-Con Invoices";
            }
            action("Sub-Con Invoice Processed")
            {
                ApplicationArea = Jobs;
                Caption = 'Sub-Con Invoices Processed';
                RunObject = page "Sub-Con Invoices Processed";
            }
        }
    }
}