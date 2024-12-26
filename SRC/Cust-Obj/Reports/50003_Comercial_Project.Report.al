report 50003 "Commercial Project-CompQ"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RdlLayout;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "Creation Date";
            column(ProjStatusReportCap; ProjStatusReportCap) { }
            column(ByReportReportCap; ByReportReportCap) { }
            column(RepCap3; RepCap3) { }
            column(RepCap4; RepCap4) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(ProjectCap; ProjectCap) { }
            column(ProjectNameCap; ProjectNameCap) { }
            column(OwingOrgCap; OwingOrgCap) { }
            column(CustomerCap; CustomerCap) { }
            column(PrimeContrcNumCap; PrimeContrcNumCap) { }
            column(TaskOrderNoCap; TaskOrderNoCap) { }
            column(SubcontaCap; SubcontaCap) { }
            column(PONOCap; PONOCap) { }
            column(PerformingOrdCap; PerformingOrdCap) { }
            column(StatusCap; StatusCap) { }
            column(ProjectClassifCap; ProjectClassifCap) { }
            column(ProjectTypeCap; ProjectTypeCap) { }
            column(PeriodOfPerCap; PeriodOfPerCap) { }
            column(StartCap; StartCap) { }
            column(EndCap; EndCap) { }
            column(ProjEctManagCap; ProjEctManagCap) { }
            column(RateTypeCap; RateTypeCap) { }
            column(BudgetRevCap; BudgetRevCap) { }
            column(BusgetTypeCap; BusgetTypeCap) { }
            column(ContractValueFeeCap; ContractValueFeeCap) { }
            column(ContractCostCap; ContractCostCap) { }
            column(ContractTotalFeeCap; ContractTotalFeeCap) { }
            column(FundedValueFeeCap; FundedValueFeeCap) { }
            column(FundedValueCostCap; FundedValueCostCap) { }
            column(FundedValueTotalCap; FundedValueTotalCap) { }
            column(IBDBIllAmountCap; IBDBIllAmountCap) { }
            column(OpenRecAmntCap; OpenRecAmntCap) { }
            column(ITDRetainiAmntCap; ITDRetainiAmntCap) { }
            column(ITDNetWithHoldingAmntCap; ITDNetWithHoldingAmntCap) { }
            column(ITDAmountCap; ITDAmountCap) { }
            column(WFFutCap; WFFutCap) { }
            column(TotalAmntCap; TotalAmntCap) { }
            column(AllModsCap; AllModsCap) { }
            column(AccNameCap; AccNameCap) { }
            column(CurrPerActCap; CurrPerActCap) { }
            column(YearToDateActCap; YearToDateActCap) { }
            column(ContrToDateCapAct; ContrToDateCapAct) { }
            column(TotalLabrCostCap; TotalLabrCostCap) { }
            column(TotalIndirectCostCap; TotalIndirectCostCap) { }
            column(TotalExpeCap; TotalExpeCap) { }
            column(ProfitCap; ProfitCap) { }
            column(ProfitPerCap; ProfitPerCap) { }
            column(LabourHrsCap; LabourHrsCap) { }
            column(UnitsCap; UnitsCap) { }
            column(PriorYearCap; PriorYearCap) { }
            column(SubPeriodCap; SubPeriodCap) { }
            column(CurrntPeriodCap; CurrntPeriodCap) { }
            column(YearToDateCap; YearToDateCap) { }
            column(ContrToDateCap; ContrToDateCap) { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Owing_Organisation; "Owing Organisation") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Prime_Contact_No_; "Prime Contact No.") { }
            column(TaskOrderNp; '') { }
            column(subcontractNo; '') { }
            column(PONum; '') { }
            column(PerformingOrd; '') { }
            column(Status; Status) { }
            column(Project_Class; "Project Class") { }
            column(Project_type; "Project type") { }
            column(Starting_Date; "Starting Date") { }
            column(Ending_Date; "Ending Date") { }
            column(Project_Manager; "Project Manager") { }
            column(Contract_Value; "Contract Value") { }
            column(Funded_Value; "Funded Value") { }
            column(Cost; Cost) { }
            column(Fee; Fee) { }
            column(Total__Cost_Fee_; "Total (Cost+Fee)") { }
            column(Rev1; Rev[1]) { }
            column(Rev2; Rev[2]) { }
            column(Rev3; Rev[3]) { }
            column(COn1; Con[1]) { }
            column(Con2; Con[2]) { }
            column(Con3; Con[3]) { }
            column(GA1; GA[1]) { }
            column(GA2; GA[2]) { }
            column(GA3; GA[3]) { }
            column(FR1; FR[1]) { }
            column(FR2; FR[2]) { }
            column(FR3; FR[3]) { }
            column(OH1; OH[1]) { }
            column(OH2; OH[2]) { }
            column(OH3; OH[3]) { }
            column(Gen___Adm__; "Gen & Adm %") { }
            column(Fringe__; "Fringe %") { }
            column(Over_Head__; "Over Head %") { }
            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
            begin
                TestField("Gen & Adm %");
                TestField("Fringe %");
                TestField("Over Head %");
                Clear(Rev);
                Clear(Con);
                Clear(GA);
                Clear(FR);
                Clear(OH);
                JobPostGrp.RESET;
                JobPostGrp.SetRange(Code, "Job Posting Group");
                IF JobPostGrp.findset then begin
                    GLEntry.Reset();
                    GLEntry.SetRange("G/L Account No.", JobPostGrp."Recognized Sales Account");
                    GLEntry.SetRange("Job No.", Job."No.");
                    IF GLEntry.FindSet then
                        repeat
                            IF Date2DMY("WIP Posting Date", 2) = Date2DMY(WorkDate, 2) then
                                Rev[1] += GLEntry.Amount;
                            IF Date2DMY("WIP Posting Date", 3) = Date2DMY(WorkDate, 3) then
                                Rev[2] += GLEntry.Amount;
                            Rev[3] += GLEntry.Amount;
                        Until GLEntry.Next() = 0;
                end;
                Rev[1] := ABS(Rev[1]);
                Rev[2] := ABS(Rev[2]);
                Rev[3] := ABS(Rev[3]);
                GLEntry.Reset();
                GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
                GLEntry.SetRange("Job No.", Job."No.");
                IF GLEntry.FindSet then
                    repeat
                        IF Date2DMY("WIP Posting Date", 2) = Date2DMY(WorkDate, 2) then
                            Con[1] += GLEntry.Amount;
                        IF Date2DMY("WIP Posting Date", 3) = Date2DMY(WorkDate, 3) then
                            Con[2] += GLEntry.Amount;
                        Con[3] += GLEntry.Amount;
                    Until GLEntry.Next() = 0;
                Con[1] := Abs(Con[1]);
                Con[2] := Abs(Con[2]);
                Con[3] := Abs(Con[3]);

                GA[1] := Con[1] * ("Gen & Adm %" / 100);
                GA[2] := Con[2] * ("Gen & Adm %" / 100);
                GA[3] := Con[3] * ("Gen & Adm %" / 100);

                GA[1] := ABS(GA[1]);
                GA[2] := ABS(GA[2]);
                GA[3] := ABS(GA[3]);

                FR[1] := Con[1] * ("Fringe %" / 100);
                FR[2] := Con[2] * ("Fringe %" / 100);
                FR[3] := Con[3] * ("Fringe %" / 100);

                FR[1] := ABS(FR[1]);
                FR[2] := ABS(FR[2]);
                FR[3] := ABS(FR[3]);

                OH[1] := Con[1] * ("Over Head %" / 100);
                OH[2] := Con[2] * ("Over Head %" / 100);
                OH[3] := Con[3] * ("Over Head %" / 100);

                OH[1] := ABS(OH[1]);
                OH[2] := ABS(OH[2]);
                OH[3] := ABS(OH[3]);

                RepCap3 := 'For Fiscal Year:' + Format(Date2DMY(WorkDate, 3)) + ' Period:' + Format(Date2DMY(WorkDate, 2));
                IF Date2DMY(WorkDate, 2) IN [1, 4, 7, 10] THEN
                    RepCap3 := RepCap3 + ' Subperiod: 1'
                else IF Date2DMY(WorkDate, 2) IN [2, 5, 8, 11] THEN
                    RepCap3 := RepCap3 + ' Subperiod: 2'
                else IF Date2DMY(WorkDate, 2) IN [3, 5, 8, 12] THEN
                    RepCap3 := RepCap3 + ' Subperiod: 3';
                RepCap4 := 'For Subperiod Ending:' + Format(WorkDate());
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
            LayoutFile = './SRC/Cust-Obj/Reports/Layout/CommercialProjectCompQ.rdl';
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
        CompInfo: Record "Company Information";
        ProjStatusReportCap: Label 'Project Status Report';
        ByReportReportCap: Label 'By Project';
        ProjectCap: Label 'Project:';
        ProjectNameCap: Label 'Project Name:';
        OwingOrgCap: Label 'Owing Org:';
        CustomerCap: Label 'Customer:';
        PrimeContrcNumCap: Label 'Prime Contract No:';
        TaskOrderNoCap: Label 'Task Order No:';
        SubcontaCap: Label 'Subcontract No:';
        PONOCap: Label 'PO No:';
        PerformingOrdCap: Label 'Performing Org:';
        StatusCap: Label 'Status:';
        ProjectClassifCap: Label 'Project Classif:';
        ProjectTypeCap: Label 'Project Type:';
        PeriodOfPerCap: Label 'Period Of Perf:';
        StartCap: Label 'Start:';
        EndCap: Label 'End:';
        ProjEctManagCap: Label 'Project Manager:';
        RateTypeCap: Label 'Rate Type:';
        BudgetRevCap: Label 'Budget Revision:';
        BusgetTypeCap: Label 'Budget Type:';
        ContractValueFeeCap: Label 'Contract Value Fee:';
        ContractCostCap: Label 'Contract Value Cost:';
        ContractTotalFeeCap: Label 'Contract Value Total:';
        FundedValueFeeCap: Label 'Funded Value Fee:';
        FundedValueCostCap: Label 'Funded Value Cost:';
        FundedValueTotalCap: Label 'Funded Value Total:';
        IBDBIllAmountCap: Label 'ID Billed Amounl:';
        OpenRecAmntCap: Label 'Open Receivable Amount:';
        ITDRetainiAmntCap: Label 'ITD Retainage Amount:';
        ITDNetWithHoldingAmntCap: Label 'ITD Net Withholding Amnt:';
        ITDAmountCap: Label 'ITD Amounts';
        WFFutCap: Label '(w/o Future Mods)';
        TotalAmntCap: Label 'Total Amounts';
        AllModsCap: Label '(All Mods)';
        AccNameCap: Label 'Account Name';
        CurrPerActCap: Label 'Current Period Actual';
        YearToDateActCap: Label 'Year To Date Actual';
        ContrToDateCapAct: Label 'Contract To Date Actual';
        TotalLabrCostCap: Label 'Total labour Cost, $:';
        TotalIndirectCostCap: Label 'Total Indirect Cost, $:';
        TotalExpeCap: Label 'Total Expenses, $:';
        ProfitCap: Label 'Profit, $';
        ProfitPerCap: Label 'Profit, %:';
        LabourHrsCap: Label 'Labour Hours';
        UnitsCap: Label 'Units';
        PriorYearCap: Label 'Prior Year';
        SubPeriodCap: Label 'Subperiod';
        CurrntPeriodCap: Label 'Current Period';
        YearToDateCap: Label 'Year To Date';
        ContrToDateCap: Label 'Contr. To Date';
        RepCap3: Text;
        RepCap4: Text;
        JobPostGrp: Record "Job Posting Group";
        Rev: array[5] of Decimal;
        Con: array[5] of Decimal;
        GA: array[5] of Decimal;
        FR: array[5] of Decimal;
        OH: array[5] of Decimal;
}