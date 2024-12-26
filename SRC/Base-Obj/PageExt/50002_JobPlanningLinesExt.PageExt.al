pageextension 50002 "Job Planning Lines Ext" extends "Job Planning Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Qty. to Transfer to Purch. Inv"; Rec."Qty. to Transfer to Purch. Inv")
            {
                ApplicationArea = all;
            }
            field("Qty. Transferred to Purch. Inv"; Rec."Qty. Transferred to Purch. Inv")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Qty. Purchase Invoiced"; Rec."Qty. Purchase Invoiced")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Update Purchase Order"; Rec."Update Purchase Order")
            {
                ApplicationArea = all;
            }
        }
        modify("Qty. Invoiced")
        {
            Visible = true;
        }
        modify("Qty. Transferred to Invoice")
        {
            Visible = true;
        }
    }

    actions
    {
        modify(CreatePurchaseOrder)
        {
            Visible = false;
        }
        addafter("Create &Sales Invoice")
        {
            action("Create &Purchase Order")
            {
                ApplicationArea = Jobs;
                Caption = 'Create/Update &Purchase Order';
                Ellipsis = true;
                Image = JobPurchaseInvoice;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Use a batch job to help you create purchase invoices for the involved job tasks.';

                trigger OnAction()
                begin
                    CreatePurchaseInvoice();
                end;
            }

            action("Show Purchase Order")
            {
                ApplicationArea = Jobs;
                Caption = 'Show Purchase Order';
                Ellipsis = true;
                Image = ShowList;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    JobModuleCustoms: Codeunit "Job Module Customs";
                begin
                    JobModuleCustoms.ShowCreatedPurchaseInvoices(Rec);
                end;
            }
        }
    }

    local procedure CreatePurchaseInvoice()
    var
        JobPlanningLine: Record "Job Planning Line";
        JobModuleCustoms: Codeunit "Job Module Customs";
    begin
        Rec.TestField("Line No.");
        Clear(JobPlanningLine);
        JobPlanningLine.Copy(Rec);
        JobModuleCustoms.CreatePurchaseInvoice(JobPlanningLine);
    end;
}