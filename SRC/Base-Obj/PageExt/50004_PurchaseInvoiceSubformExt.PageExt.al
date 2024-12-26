pageextension 50004 "Purch. Invoice Subform Ext" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field("Charge Code"; Rec."Charge Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Job No.")
        {
            Visible = true;
            Editable = true;
        }
        modify("Job Task No.")
        {
            Visible = true;
            Editable = true;
        }

        modify(Description)
        {
            Caption = 'Contractor/Resource Name';
        }
        modify("Description 2")
        {
            caption = 'Description/Memo';
            Visible = true;
        }



        modify("Direct Unit Cost")
        {
            Caption = 'Pay Rate Under Resouce Type';
            CaptionClass = 'Pay Rate Under Resouce Type';
        }

        addafter(Description)
        {
            field("Job Resource No."; Rec."Job Resource No.")
            {
                ApplicationArea = all;
            }
            field("Job Res. Name"; Rec."Job Res. Name")
            {
                ApplicationArea = all;
            }
            field("JobNo."; Rec."Job No.")
            {
                ApplicationArea = all;
            }
            field("Job Name"; Rec."Job Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Name field.';
            }
            field("Job TaskNo."; Rec."Job Task No.")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addafter(GetReceiptLines)
        {
            action(GetJobEntries)
            {
                ApplicationArea = All;
                Caption = 'Get Job Entries';
                Ellipsis = true;
                Image = GetLines;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    PurchLine: Record "Purchase Line";
                    PurchHeader: Record "Purchase Header";
                    JobPlanningLine: Record "Job Planning Line";
                    Job: Record Job;
                    JobPostingGroup: Record "Job Posting Group";
                    JobModule: Codeunit "Job Module Customs";
                    GLEntries: Page "General Ledger Entries";
                begin
                    if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                        GLEntry.Reset();
                        GLEntry.SetRange("Vendor No. B2B", PurchHeader."Buy-from Vendor No.");
                        GLEntry.SetRange("Invoice No. B2B", '');
                        if GLEntry.FindSet() then begin
                            Clear(GLEntries);
                            GLEntries.LookupMode(true);
                            GLEntries.SetTableView(GLEntry);
                            if GLEntries.RunModal() = Action::LookupOK then begin
                                GLEntry.Reset();
                                GLEntries.SetSelectionFilter(GLEntry);
                                if GLEntry.FindSet() then
                                    repeat
                                        JobPlanningLine.Reset();
                                        JobPlanningLine.SetRange("Job No.", GLEntry."Job No.");
                                        JobPlanningLine.SetRange("Job Task No.", GLEntry."Job Task No. B2B");
                                        JobPlanningLine.SetRange(Type, JobPlanningLine.Type::Resource);
                                        JobPlanningLine.SetRange("No.", GLEntry."Resource No. B2B");
                                        JobPlanningLine.SetRange("Line No.", GLEntry."Job Planning Line No. B2B");
                                        if JobPlanningLine.FindFirst() then begin
                                            Job.Get(JobPlanningLine."Job No.");
                                            if JobPostingGroup.Get(Job."Job Posting Group") then;
                                            JobModule.CreatePurchaseLine(JobPlanningLine, PurchHeader, Job, JobPostingGroup);
                                        end;
                                    until GLEntry.Next() = 0;
                            end;
                        end;
                    end;
                end;
            }
        }
    }
}