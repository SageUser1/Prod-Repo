reportextension 50000 "Job Calculate WIP Ext B2B" extends "Job Calculate WIP"
{
    dataset
    {
        modify(Job)
        {
            trigger OnAfterAfterGetRecord()
            begin
                CreateCustomWIPEntry(Job);
            end;
        }
    }

    local procedure CreateCustomWIPEntry(Job: Record Job)
    var
        JobWIPEntry2: Record "Job WIP Entry";
        JobWIPEntry3: Record "Job WIP Entry";
        JobWIPMethod: Record "Job WIP Method";
        NextEntryNo: Integer;
        JobPostingGroup: Record "Job Posting Group";
        CreateEntry: Boolean;
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLine2: Record "Job Planning Line";
        PrevJobResouceNo: Code[20];
        Resource: Record Resource;
        WIPAmount: Decimal;
    begin
        JobWIPEntry2.Reset();
        JobWIPEntry2.SetRange("Job No.", Job."No.");
        if JobWIPEntry2.FindLast() then
            NextEntryNo := JobWIPEntry2."Entry No." + 1;

        JobWIPMethod.Get(Job."WIP Method");
        JobPlanningLine.Reset();
        JobPlanningLine.SetCurrentKey("No.");
        JobPlanningLine.SetRange("Job No.", Job."No.");
        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SetFilter("Line Type", '<>%1', JobPlanningLine."Line Type"::Budget);
        JobPlanningLine.SetFilter(Quantity, '<>0');
        if JobPlanningLine.FindSet() then begin
            repeat
                if PrevJobResouceNo <> JobPlanningLine."No." then begin
                    PrevJobResouceNo := JobPlanningLine."No.";
                    Job.Get(JobPlanningLine."Job No.");
                    if (Resource.Get(JobPlanningLine."No.")) and (Resource."Sub-Contracting Resource") then begin
                        JobPostingGroup.Get(Job."Job Posting Group");
                        JobPostingGroup.TestField("Sub-Contracting Cost");
                        JobPostingGroup.TestField("Sub-Contracting Accrual cost");

                        JobPlanningLine2.Reset();
                        JobPlanningLine2.CopyFilters(JobPlanningLine);
                        JobPlanningLine2.SetRange("No.", JobPlanningLine."No.");
                        if JobPlanningLine2.FindSet() then
                            JobPlanningLine2.CalcSums("Total Cost");
                        if JobPlanningLine2."Total Cost" <> 0 then begin
                            InsertCustomWIPEntry(Job, JobWIPEntry2, JobPostingGroup, JobPlanningLine2, NextEntryNo, Resource);
                            NextEntryNo := NextEntryNo + 1;
                        end;


                    end;
                end;
            until JobPlanningLine.Next() = 0;
        end;
    end;

    local procedure InsertCustomWIPEntry(Job: Record Job; JobWIPEntry2: Record "Job WIP Entry"; JobPostingGroup: Record "Job Posting Group";
                                         JobPlanningLine2: Record "Job Planning Line"; NextEntryNo: Integer; Resource: Record Resource)
    var
        JobWIPEntry: Record "Job WIP Entry";
        DimMgt: Codeunit DimensionManagement;
    begin
        Clear(JobWIPEntry);
        JobWIPEntry.Init();
        JobWIPEntry."Job No." := Job."No.";
        JobWIPEntry."WIP Posting Date" := JobWIPEntry2."WIP Posting Date";
        JobWIPEntry."Document No." := JobWIPEntry2."Document No.";
        JobWIPEntry.Type := JobWIPEntry.Type::"Accrued Costs";
        JobWIPEntry."Job Posting Group" := Job."Job Posting Group";
        JobWIPEntry."G/L Account No." := JobPostingGroup."Sub-Contracting Cost";
        JobWIPEntry."G/L Bal. Account No." := JobPostingGroup."Sub-Contracting Accrual cost";
        JobWIPEntry."WIP Method Used" := Job."WIP Method";
        JobWIPEntry."Job Complete" := JobWIPEntry."Job Complete";
        JobWIPEntry."Job WIP Total Entry No." := JobWIPEntry2."Job WIP Total Entry No.";
        JobWIPEntry."WIP Entry Amount" := Round(JobPlanningLine2."Total Cost");
        JobWIPEntry.Reverse := JobWIPEntry2.Reverse;
        JobWIPEntry."WIP Posting Method Used" := JobWIPEntry."WIP Posting Method Used"::"Per Job";
        JobWIPEntry."Entry No." := NextEntryNo;
        JobWIPEntry."Vendor No. B2B" := Resource."Sub-Con. Resource Vendor";
        JobWIPEntry."Job Task No. B2B" := JobPlanningLine2."Job Task No.";
        JobWIPEntry."Job Planning Line No. B2B" := JobPlanningLine2."Line No.";
        JobWIPEntry."Resource No. B2B" := JobPlanningLine2."No.";
        JobWIPEntry."Custom WIP Entry" := true;
        JobWIPEntry."Dimension Set ID" := JobWIPEntry2."Dimension Set ID";
        DimMgt.UpdateGlobalDimFromDimSetID(JobWIPEntry."Dimension Set ID", JobWIPEntry."Global Dimension 1 Code",
          JobWIPEntry."Global Dimension 2 Code");
        JobWIPEntry.Insert(true);
    end;

    local procedure InsertReverseWIPEntry(Job: Record Job; JobWIPEntry2: Record "Job WIP Entry"; JobPostingGroup: Record "Job Posting Group";
                                         JobPlanningLine2: Record "Job Planning Line"; NextEntryNo: Integer; Resource: Record Resource)
    var
        JobWIPEntry: Record "Job WIP Entry";
        DimMgt: Codeunit DimensionManagement;
    begin
        Clear(JobWIPEntry);
        JobWIPEntry.Init();
        JobWIPEntry."Job No." := Job."No.";
        JobWIPEntry."WIP Posting Date" := JobWIPEntry2."WIP Posting Date";
        JobWIPEntry."Document No." := JobWIPEntry2."Document No.";
        JobWIPEntry.Type := JobWIPEntry.Type::"Accrued Costs";
        JobWIPEntry."Job Posting Group" := Job."Job Posting Group";
        JobWIPEntry."G/L Account No." := JobPostingGroup."WIP Costs Account";
        JobWIPEntry."G/L Bal. Account No." := JobPostingGroup."Recognized Costs Account";
        JobWIPEntry."WIP Method Used" := Job."WIP Method";
        JobWIPEntry."Job Complete" := JobWIPEntry."Job Complete";
        JobWIPEntry."Job WIP Total Entry No." := JobWIPEntry2."Job WIP Total Entry No.";
        JobWIPEntry."WIP Entry Amount" := Round(JobPlanningLine2."Total Cost");
        JobWIPEntry.Reverse := JobWIPEntry2.Reverse;
        JobWIPEntry."WIP Posting Method Used" := JobWIPEntry."WIP Posting Method Used"::"Per Job";
        JobWIPEntry."Entry No." := NextEntryNo;
        JobWIPEntry."Vendor No. B2B" := Resource."Sub-Con. Resource Vendor";
        JobWIPEntry."Job Task No. B2B" := JobPlanningLine2."Job Task No.";
        JobWIPEntry."Job Planning Line No. B2B" := JobPlanningLine2."Line No.";
        JobWIPEntry."Resource No. B2B" := JobPlanningLine2."No.";
        JobWIPEntry."Custom WIP Entry" := true;
        JobWIPEntry."Dimension Set ID" := JobWIPEntry2."Dimension Set ID";
        DimMgt.UpdateGlobalDimFromDimSetID(JobWIPEntry."Dimension Set ID", JobWIPEntry."Global Dimension 1 Code",
          JobWIPEntry."Global Dimension 2 Code");
        JobWIPEntry.Insert(true);
    end;
}