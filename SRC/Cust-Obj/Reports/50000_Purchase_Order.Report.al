report 50000 "Purchase Orde - CompQ"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLC;
    Caption = 'Purchase Orde - CompQ';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = filter("Document Type"::order));
            RequestFilterFields = "No.", "Document Date";
            column(ReportCaptlbl; ReportCaptlbl) { }
            column(DatePrintedlbl; DatePrintedlbl) { }
            column(TransCurrlbl; TransCurrlbl) { }
            column(Ordertolbl; Ordertolbl) { }
            column(Shiptolbl; Shiptolbl) { }
            column(OrderDatelbl; OrderDatelbl) { }
            column(Buyerlbl; Buyerlbl) { }
            column(Termslbl; Termslbl) { }
            column(FOBlbl; FOBlbl) { }
            column(Salorder; Salorder) { }
            column(ShipVialbl; ShipVialbl) { }
            column(Delibertolbl; Delibertolbl) { }
            column(Linelbl; Linelbl) { }
            column(Itemdesclbl; Itemdesclbl) { }
            column(Revlbl; Revlbl) { }
            column(DueDatelbl; DueDatelbl) { }
            column(DesDatelbl; DesDatelbl) { }
            column(UMlbl; UMlbl) { }
            column(OrdrQtylbl; OrdrQtylbl) { }
            column(Netcsylbl; Netcsylbl) { }
            column(Extcostlbl; Extcostlbl) { }
            column(Billtolbl; Billtolbl) { }
            column(PototalCap; PototalCap) { }
            column(No_; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Vendor_Order_No_; "Vendor Order No.") { }
            column(Location_Code; "Location Code") { }
            column(FOB; FOB) { }
            column(Ship_Via; "Ship Via") { }
            column(Due_Date; "Due Date") { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                column(Line_No_; Lineno) { }
                column(ItemNo_; "No.") { }
                column(Description; Description) { }
                column(Expected_Receipt_Date; "Expected Receipt Date") { }
                column(Promised_Receipt_Date; "Promised Receipt Date") { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_of_Measure; "Unit of Measure") { }
                dataitem("Purch. Comment Line"; "Purch. Comment Line")
                {
                    DataItemLinkReference = "Purchase Line";
                    DataItemLink = "Document Type" = field("Document Type"), "No." = field("Document No."), "Document Line No." = field("Line No.");
                    column(Lineno; Lineno) { }
                    column(Comment; Comment) { }
                }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Lineno += 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
                VendLrec: Record Vendor;
                VendTypeLrec: Record "Vendor Type";
            begin
                Lineno := 0;
                IF VendLrec.GET("Buy-from Vendor No.") then
                    IF VendTypeLrec.GET(VendLrec."Vendor Type") then
                        IF VendTypeLrec."Sub-Con Vendor" then
                            CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Details)
                {

                }
            }
        }


    }

    rendering
    {
        layout(RDLC)
        {
            Type = RDLC;
            LayoutFile = './SRC/Cust-Obj/Reports/Layout/PurchaseOrderCompQ.rdl';
        }
    }

    var
        ReportCaptlbl: Label 'Purchase Order: ';
        ReportCaptlbl2: Label 'CQSITL1003';
        DatePrintedlbl: Label 'Date Printed:';
        TransCurrlbl: Label 'Trans Currency:';
        Ordertolbl: Label 'Order To:';
        Shiptolbl: Label 'Ship To:';
        OrderDatelbl: Label 'Order Date';
        Buyerlbl: label 'Buyer';
        Termslbl: label 'Terms';
        FOBlbl: Label 'FOB';
        Salorder: Label 'Sales Order';
        ShipVialbl: label 'Ship Via';
        Delibertolbl: Label 'Deliver To';
        Linelbl: Label 'Line';
        Itemdesclbl: label 'Item/Description';
        Revlbl: label 'Rev';
        DueDatelbl: Label 'Due Date';
        DesDatelbl: Label 'Desired Date';
        UMlbl: label 'UM';
        OrdrQtylbl: Label 'Order Quantity';
        Netcsylbl: Label 'Net unit Cost';
        Extcostlbl: Label 'Extended Cost';
        Billtolbl: Label 'Bill To:';
        PototalCap: Label 'PO Total Amount';
        Lineno: Integer;

}