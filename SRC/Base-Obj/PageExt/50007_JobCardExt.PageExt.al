pageextension 50007 "Job Card Ext" extends "Job Card"
{
    layout
    {
        addafter("Project Manager")
        {
            field("Charge Code"; Rec."Charge Code")
            {
                ApplicationArea = all;
            }
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = all;
            }
            field(Cost; Rec.Cost)
            {
                ApplicationArea = all;
            }
            field(Fee; Rec.Fee)
            {
                ApplicationArea = all;
            }

            field("Total (Cost+Fee)"; Rec."Total (Cost+Fee)")
            {
                ApplicationArea = all;
            }
            field("Owing Organisation"; Rec."Owing Organisation")
            {
                ApplicationArea = all;
            }
            field("Prime Contact No."; Rec."Prime Contact No.")
            {
                ApplicationArea = all;
            }
            field("Project Class"; Rec."Project Class")
            {
                ApplicationArea = all;
            }
            field("Project type"; Rec."Project type")
            {
                ApplicationArea = all;
            }
            field("Contract Value"; Rec."Contract Value")
            {
                ApplicationArea = all;
            }
            field("Funded Value"; Rec."Funded Value")
            {
                ApplicationArea = all;
            }
            field("Gen & Adm %"; Rec."Gen & Adm %")
            {
                ApplicationArea = all;
            }
            field("Fringe %"; Rec."Fringe %")
            {
                ApplicationArea = all;
            }
            field("Over Head %"; Rec."Over Head %")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(TimeSheetLines)
        {
            action("TimeSheetLines - 15D")
            {
                ApplicationArea = Jobs;
                Caption = 'Time Sheet Lines - 15D';
                Image = LinesFromTimesheet;
                ToolTip = 'View which time sheet lines are referencing this project.';

                trigger OnAction()
                var
                    TimeSheetLine: Record "Time Sheet Line";
                    TimeSheetLineList: Page "Time Sheet Line List - 15D";
                begin
                    TimeSheetLine.FilterGroup(2);
                    TimeSheetLine.SetRange(Type, TimeSheetLine.Type::Job);
                    TimeSheetLine.SetRange("Job No.", Rec."No.");
                    TimeSheetLine.SetRange(Posted, false);
                    TimeSheetLine.FilterGroup(0);

                    TimeSheetLineList.SetTableView(TimeSheetLine);
                    TimeSheetLineList.Run();
                end;
            }
        }
        addafter("Job Analysis")
        {
            action("Print-CompQ")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print-CompQ (Comercial)';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    JobLrec: Record Job;
                begin
                    JobLrec.RESET;
                    JobLrec.SetRange("No.", rec."No.");
                    IF JobLrec.FindFirst() then
                        Report.RunModal(50003, true, false, JobLrec);
                end;
            }
        }
        modify(TimeSheetLines)
        {
            Visible = false;
        }

    }
}