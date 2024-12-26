pageextension 50025 "Purchase Order Ext" extends "Purchase Order"
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


    }
}