pageextension 50013 PurchOrderExt extends "Purchase Order"
{
    layout
    {
        modify("Vendor Order No.")
        {
            Caption = 'Sales Order No.';
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action(PrintCompQReport)
            {
                ApplicationArea = Suite;
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
                Caption = 'Print-CompQ';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    PurchHdrLrec: Record "Purchase Header";
                    VendLrec: Record Vendor;
                    VendTypeLrec: Record "Vendor Type";
                    PurchOrderRep: Report "Purchase Orde - CompQ";
                    PurchOrderSubRep: Report "Purchase Orde SubCOn - CompQ";
                begin
                    PurchHdrLrec.Reset();
                    PurchHdrLrec.SetRange("No.", Rec."No.");
                    IF PurchHdrLrec.FindFirst() then begin
                        IF VendLrec.GET(PurchHdrLrec."Buy-from Vendor No.") then
                            IF VendTypeLrec.GET(VendLrec."Vendor Type") then begin
                                IF VendTypeLrec."Sub-Con Vendor" then
                                    Report.RunModal(50001, true, false, PurchHdrLrec)
                                else
                                    Report.RunModal(50000, true, false, PurchHdrLrec);
                            end else
                                Report.RunModal(50000, true, false, PurchHdrLrec);
                    end
                end;
            }
        }
    }

    var
        myInt: Integer;
}