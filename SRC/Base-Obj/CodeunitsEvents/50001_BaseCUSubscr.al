codeunit 50001 BaseCUSubsc
{
    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Calculate WIP", 'OnInsertWIPGLOnBeforeGenJnPostLine', '', false, false)]
    local procedure OnInsertWIPGLOnBeforeGenJnPostLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        JobWIPEntry: Record "Job WIP Entry";
    begin
        JobWIPEntry.Reset();
        JobWIPEntry.SetRange("Job No.", GenJournalLine."Job No.");
        JobWIPEntry.SetRange("Document No.", GenJournalLine."Document No.");
        JobWIPEntry.SetRange("G/L Account No.", GenJournalLine."Account No.");
        JobWIPEntry.SetRange("G/L Bal. Account No.", GenJournalLine."Bal. Account No.");
        JobWIPEntry.SetRange("Custom WIP Entry", true);
        if JobWIPEntry.FindFirst() then begin
            GenJournalLine."Vendor No. B2B" := JobWIPEntry."Vendor No. B2B";
            GenJournalLine."Job Task No. B2B" := JobWIPEntry."Job Task No. B2B";
            GenJournalLine."Job Planning Line No. B2B" := JobWIPEntry."Job Planning Line No. B2B";
            GenJournalLine."Resource No. B2B" := JobWIPEntry."Resource No. B2B";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine_B2B(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Vendor No. B2B" := GenJournalLine."Vendor No. B2B";
        GLEntry."Job Task No. B2B" := GenJournalLine."Job Task No. B2B";
        GLEntry."Resource No. B2B" := GenJournalLine."Resource No. B2B";
        GLEntry."Job Planning Line No. B2B" := GenJournalLine."Job Planning Line No. B2B";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnFinalizePostingOnBeforeUpdateAfterPosting', '', false, false)]
    local procedure OnFinalizePostingOnBeforeUpdateAfterPosting(var PurchHeader: Record "Purchase Header")
    var
        JobPlanningLine: Record "Job Planning Line";
        SubConInvProcessed: Record "Sub-Con Invoice Processed";
        SubConInvoice: Record "Sub-Con Invoice";
    begin
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Subcon. Invoice No.", PurchHeader."No.");
        if JobPlanningLine.FindSet() then
            repeat
                JobPlanningLine."Qty. Purchase Invoiced" := JobPlanningLine."Qty. Transferred to Purch. Inv";
                JobPlanningLine.Modify();

                SubConInvProcessed.Reset();
                SubConInvProcessed.SetRange("Job No.", JobPlanningLine."Job No.");
                SubConInvProcessed.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
                SubConInvProcessed.SetRange("Job Task Line No.", JobPlanningLine."Line No.");
                SubConInvProcessed.SetRange("Sub-Con Invoice No.", PurchHeader."No.");
                if SubConInvProcessed.FindFirst() then begin
                    SubConInvProcessed."Qty. Purchase Invoiced" := JobPlanningLine."Qty. Purchase Invoiced";
                    SubConInvProcessed."Remaining Qty." := SubConInvProcessed.Quantity - SubConInvProcessed."Qty. Purchase Invoiced";
                    SubConInvProcessed.Modify();
                end;

                SubConInvoice.Reset();
                if SubConInvoice.FindSet() then
                    SubConInvoice.DeleteAll();
            until JobPlanningLine.Next() = 0;
    end;

    var
        GLDocumentNo: Code[20];
}