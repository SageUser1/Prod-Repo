pageextension 50005 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field(Memo; Rec.Memo)
            {
                ApplicationArea = all;
            }
            field(FOB; Rec.FOB)
            {
                ApplicationArea = all;
            }
            field("Ship Via"; Rec."Ship Via")
            {
                ApplicationArea = all;
            }
        }

        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Tax Exemption No.")
        {
            Visible = false;
        }
    }
}