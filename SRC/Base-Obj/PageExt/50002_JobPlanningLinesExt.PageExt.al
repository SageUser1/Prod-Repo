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
            //Visible = false;
            Caption = 'Base Action - Create Purchase Order';
        }
        addafter("Create &Sales Invoice")
        {
            action("Create &Purchase Order")
            {
                ApplicationArea = Jobs;
                Caption = 'Create/Update &Purchase Document';
                Ellipsis = true;
                Image = JobPurchaseInvoice;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Use a batch job to help you create purchase order/ invoices for the involved job tasks.';

                trigger OnAction()
                begin
                    CreatePurchaseInvoice(rec);
                end;
            }

            action("Show Purchase Order")
            {
                ApplicationArea = Jobs;
                Caption = 'Show Purchase Document';
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

    local procedure CreatePurchaseInvoice(JobPlanningLineLpar: Record "Job Planning Line")
    var
        JobPlanningLine: Record "Job Planning Line";
        JobModuleCustoms: Codeunit "Job Module Customs";
    begin
        JobPlanningLineLpar.TestField("Line No.");
        Clear(JobPlanningLine);
        JobPlanningLine.Copy(JobPlanningLineLpar);
        JobModuleCustoms.CreatePurchaseInvoice(JobPlanningLine);
    end;
}