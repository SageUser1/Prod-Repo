pageextension 50014 PostedSalesInvPageExt extends "Sales invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action("Print-CompQ")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print-CompQ';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    PostedSalesInv: Record "Sales Header";
                    CustomerInvReport: Report "Customer Report - CompQ";
                begin
                    PostedSalesInv.RESET;
                    PostedSalesInv.SetRange("No.", rec."No.");
                    IF PostedSalesInv.FindFirst() then
                        Report.RunModal(50002, true, false, PostedSalesInv);
                end;
            }
        }
    }

    var
        myInt: Integer;
}