report 50002 "Customer Report - CompQ"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RdlLayout;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAdd; CompInfo.Address) { }
            column(CompInfoAdd2; CompInfo."Address 2") { }
            column(CompInfopostCode; CompInfo."Post Code") { }
            column(ReportCap; ReportCap) { }
            column(InvNumbCap; InvNumbCap) { }
            column(InvDateCap; InvDateCap) { }
            column(BillToCap; BillToCap) { }
            column(RemitToCap; RemitToCap) { }
            column(CustNumbCap; CustNumbCap) { }
            column(SubContValueCap; SubContValueCap) { }
            column(CustomPoNumbCap; CustomPoNumbCap) { }
            column(TaskOrderNumCap; TaskOrderNumCap) { }
            column(ProjNumCap; ProjNumCap) { }
            column(ProjNameCap; ProjNameCap) { }
            column(ProjePOPCap; ProjePOPCap) { }
            column(TermsCap; TermsCap) { }
            column(DueDateCap; DueDateCap) { }
            column(InvTotalCap; InvTotalCap) { }
            column(CurrentIncuHrsCap; CurrentIncuHrsCap) { }
            column(CummuIncHrsCap; CummuIncHrsCap) { }
            column(ContractValueCap; ContractValueCap) { }
            column(FundedValueCap; FundedValueCap) { }
            column(CostCap; CostCap) { }
            column(FeeCap; FeeCap) { }
            column(TotalCap; TotalCap) { }
            column(PercOfTotalBilledCap; PercOfTotalBilledCap) { }
            column(CummAmntBilledCap; CummAmntBilledCap) { }
            column(BillingPerCap; BillingPerCap) { }
            column(ToCap; ToCap) { }
            column(HoursCap; HoursCap) { }
            column(Rate; Rate) { }
            column(CurrentAmntCap; CurrentAmntCap) { }
            column(CummulHoursCap; CummulHoursCap) { }
            column(CummulativeAmountCap; CummulativeAmountCap) { }
            column(No_; "No.") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Customer_Name_2; "Sell-to Customer Name 2") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_Address_2; "Sell-to Address 2") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(Document_Date; "Document Date") { }
            column(Sub__Contract__No_; "Sub. Contract. No.") { }
            column(Customer_PO_No_; "Customer PO No.") { }
            column(Task_Order_No_; "Task Order No.") { }
            column(JobNo; Job."No.") { }
            column(JobDesc; Job.Description) { }
            column(JobStDate; FORMAT(job."Starting Date") + ' to ' + FOrmat(job."Ending Date")) { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(JobCost; Job.Cost) { }
            column(JobFess; Job.Fee) { }
            column(Due_Date; "Due Date") { }
            column(JobTotal; Job."Total (Cost+Fee)") { }
            column(Billing_From_Period; "Billing From Period") { }
            column(Billing_To_Period; "Billing To Period") { }
            column(JobPerComp; Job.PercentCompleted) { }
            column(PageHide; PageHide) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Line_No_; "Line No.") { }
                column(LineNo_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Price") { }
                column(Line_Amount; "Line Amount") { }
                column(QtyHide; QtyHide) { }
                dataitem("Sales Invoice Line"; "Sales Invoice Line")
                {
                    DataItemLink = "Job No." = field("Job No.");
                    column(SINVDocument_No_; Description) { }
                    column(SInvLLine_No_; "Line No.") { }
                    column(Type; Type) { }
                    column(SInvNo_; "No.") { }
                    column(SINvDescription; Description) { }
                    column(SINQuantity; Quantity) { }
                    column(SInvAmount; Amount) { }
                    column(SInvUnit_Cost; "Unit Price") { }
                    column(SInvPosting_Date; "Posting Date") { }
                    column(SInvJob_No_; "Job No.") { }
                    column(SinvJobDesc; Job.Description) { }
                    column(SaleQty; SalesInvLine.Quantity) { }
                    column(SalLineAmnt; SalesInvLine."Line Amount") { }
                    column(SaleLine2Amnt; SaleLine2.Amount) { }
                    column(SaleLine2Qty; SaleLine2.Quantity) { }
                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin
                        IF "Sales Header"."Project Class" = "Sales Header"."Project Class"::CPFF then
                            CurrReport.Skip();
                    end;

                }
                trigger OnAfterGetRecord()
                var
                begin
                    IF Type = Type::"G/L Account" then
                        QtyHide := 0
                    else
                        QtyHide := Quantity;

                    SalesInvLine.RESET;
                    SalesInvLine.SetRange("Job No.", "Job No.");
                    SalesInvLine.SetRange("Job Task No.", "Job Task No.");
                    //SalesInvLine.SetRange("No.", "No.");
                    IF SalesInvLine.FINDSET THEN
                        SalesInvLine.CalcSums(Quantity, "Line Amount");

                    SaleLine2.RESET;
                    SaleLine2.SetRange("Document Type", "Document Type");
                    SaleLine2.SetRange("Document No.", "Document No.");
                    IF SaleLine2.FINDSET THEN
                        SaleLine2.CalcSums(Quantity, "Line Amount");
                end;
            }
            trigger OnAfterGetRecord()
            var
                SaleLine: Record "Sales Line";
                SalesInvLine: Record "Sales Invoice Line";
            begin
                IF "Project Class" = "Project Class"::CPFF then
                    PageHide := true
                else
                    PageHide := false;
                SaleLine.RESET;
                SaleLine.SetRange("Document Type", "Document Type");
                SaleLine.SetRange("Document No.", "No.");
                SaleLine.SetFilter("Job No.", '<>%1', '');
                IF SaleLine.FindFirst() THEN begin
                    Job.RESET;
                    Job.SetRange("No.", SaleLine."Job No.");
                    IF Job.FindFirst() THEN;
                end;
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
                group(GroupName)
                {

                }
            }
        }


    }

    rendering
    {
        layout(RdlLayout)
        {
            Type = RDLC;
            LayoutFile = './SRC/Cust-Obj/Reports/Layout/CustomerInvoiceCompQ.rdl';
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        CompInfo.get();
        CompInfo.CalcFields(Picture);
    end;

    var
        SaleLine2: Record "Sales Line";
        SalesInvLine: Record "Sales Invoice Line";
        CompInfo: Record "Company Information";
        ReportCap: Label 'CompQSoft';
        InvNumbCap: Label 'Invoice Number:';
        InvDateCap: Label 'Invoice Date:';
        BillToCap: Label 'Bill To:';
        RemitToCap: Label 'Remit To:';
        CustNumbCap: Label 'Customer Number:';
        SubContValueCap: Label 'Subcontractor Number:';
        CustomPoNumbCap: Label 'Customer PO Number:';
        TaskOrderNumCap: Label 'Task order Number:';
        ProjNumCap: Label 'Project Number:';
        ProjNameCap: Label 'Project Name:';
        ProjePOPCap: Label 'Project POP:';
        TermsCap: Label 'Terms:';
        DueDateCap: Label 'Due Date:';
        InvTotalCap: Label 'Invoice Total:';
        CurrentIncuHrsCap: Label 'Current Incurred Hours:';
        CummuIncHrsCap: Label 'Cummulative Incurred Hours:';
        ContractValueCap: Label 'Contract Value';
        FundedValueCap: Label 'Funded value';
        CostCap: Label 'Cost:';
        FeeCap: Label 'Fee:';
        TotalCap: Label 'Total:';
        PercOfTotalBilledCap: Label 'Percent of Total Billed:';
        CummAmntBilledCap: Label 'Cummulative Amount Billed:';
        BillingPerCap: Label 'Billing Period From:';
        ToCap: Label 'To:';
        HoursCap: Label 'Hours';
        Rate: Label 'Rate';
        CurrentAmntCap: Label 'Current Amount:';
        CummulHoursCap: Label 'Cummulative Hours:';
        CummulativeAmountCap: Label 'Cummulative Amount:';
        Job: Record job;
        PageHide: Boolean;
        QtyHide: Decimal;

}