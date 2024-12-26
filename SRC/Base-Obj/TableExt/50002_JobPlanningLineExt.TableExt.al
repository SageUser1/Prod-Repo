tableextension 50002 "Job Planning Line Ext" extends "Job Planning Line"
{
    fields
    {
        field(50000; "Qty. to Transfer to Purch. Inv"; Decimal)
        {
            Caption = 'Qty. to Transfer to Purch. Invoice';

            trigger OnValidate()
            var
                Resource: Record Resource;
                ErrTxt: Label '%1 is not a sub-contracting resource. Hence, Purchase Invoice will not be created.';
                ErrTxt1: Label 'Qty. to Transfer to Purch. Invoice must be less than or equal to %1.';
            begin
                TestField(Type, Type::Resource);
                if not ((Resource.Get("No.")) and Resource."Sub-Contracting Resource") then
                    Error(ErrTxt, "No.");

                if Rec."Qty. to Transfer to Purch. Inv" > (Quantity - "Qty. Purchase Invoiced") then
                    Error(ErrTxt1, Format(Quantity - "Qty. Purchase Invoiced"));
            end;
        }
        field(50001; "Subcon. Invoice No."; Code[20])
        {
            Caption = 'Subcon. Invoice No.';
        }
        field(50002; "Subcon. Invoice Line No."; Integer)
        {
            Caption = 'Subcon. Invoice Line No.';
        }
        field(50003; "Qty. Transferred to Purch. Inv"; Decimal)
        {
            Editable = false;
        }
        field(50004; "Qty. Purchase Invoiced"; Decimal)
        {
            Editable = false;
        }
        field(50005; "Update Purchase Order"; Code[20])
        {
            TableRelation = "Purchase Line"."Document No." where("Document Type" = filter(Order), "Job No." = field("Job No."), "Job Resource No." = field("No."));
        }
    }

}