page 50011 "Manager Time Sheet List - 15D"
{
    ApplicationArea = Jobs;
    Caption = 'Manager Time Sheets - 15D';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    CardPageID = "Time Sheet Card - 15D";
    RefreshOnActivate = true;
    SourceTable = "Time Sheet Header";
    SourceTableView = sorting("Resource No.", "Starting Date") order(descending);
    UsageCategory = Tasks;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the starting date for a time sheet.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ending date for a time sheet.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description for a time sheet.';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the resource for the time sheet.';
                }
                field("Resource Name 2"; Rec."Resource Name 2")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the resource for the time sheet.';
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the resource for the time sheet.';
                    Visible = false;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    ToolTip = 'Specifies the total number of hours that are registered on the time sheet.';
                }
                field("Quantity Open"; Rec."Quantity Open")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Open';
                    ToolTip = 'Specifies the total number of hours with the status Open on the time sheet.';
                }
                field("Quantity Submitted"; Rec."Quantity Submitted")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Submitted';
                    ToolTip = 'Specifies the total number of hours with the status Submitted on the time sheet.';
                }
                field("Quantity Approved"; Rec."Quantity Approved")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Approved';
                    ToolTip = 'Specifies the total number of hours with the status Approved on the time sheet.';
                }
                field("Quantity Rejected"; Rec."Quantity Rejected")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Rejected';
                    ToolTip = 'Specifies the total number of hours with the status Rejected on the time sheet.';
                }
                field("Open Exists"; Rec."Open Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies if there are time sheet lines with the status Open.';
                }
                field("Submitted Exists"; Rec."Submitted Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies if there are time sheet lines with the status Submitted.';
                }
                field("Rejected Exists"; Rec."Rejected Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies whether there are time sheet lines with the status Rejected.';
                }
                field("Approved Exists"; Rec."Approved Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies whether there are time sheet lines with the status Approved.';
                }
                field("Posted Exists"; Rec."Posted Exists")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies whether there are time sheet lines with the status Posted.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    DrillDown = false;
                    ToolTip = 'Specifies that a comment about this document has been entered.';
                }
            }
        }
        /*area(factboxes)
        {
            part(TimeSheetComments; "Time Sheet Comments FactBox")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Time Sheet Comments';
                SubPageLink = "No." = field("No."), "Time Sheet Line No." = filter(0); //just header comments                
                Editable = false;
            }
        }*/
    }

    actions
    {
        area(processing)
        {
            action("Edit Time Sheet")
            {
                ApplicationArea = Jobs;
                Caption = 'Review Time Sheet';
                Image = OpenJournal;
                ShortCutKey = 'Return';
                ToolTip = 'Open the time sheet to approve its details. This requires that you''re the time sheet owner, administrator, or approver.';

                trigger OnAction()
                begin
                    ReviewTimeSheet();
                end;
            }
            action(MoveTimeSheetsToArchive)
            {
                ApplicationArea = Jobs;
                Caption = 'Move Time Sheets to Archive';
                Image = Archive;
                ToolTip = 'Archive time sheets.';
                Visible = TimeSheetAdminActionsVisible;
                Enabled = ArchiveEnabled and TimeSheetAdminActionsVisible;

                trigger OnAction()
                var
                    TimeSheetHeader: Record "Time Sheet Header";
                    MoveTimeSheetstoArchive: Report "Move Time Sheets to Archive";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecordRef: RecordRef;
                    TimeSheetNoFilter: Text;
                begin
                    CurrPage.SetSelectionFilter(TimeSheetHeader);
                    RecordRef.GetTable(TimeSheetHeader);
                    TimeSheetNoFilter := SelectionFilterManagement.GetSelectionFilter(RecordRef, TimeSheetHeader.FieldNo("No."));
                    TimeSheetHeader.SetFilter("No.", TimeSheetNoFilter);
                    MoveTimeSheetstoArchive.SetTableView(TimeSheetHeader);
                    MoveTimeSheetstoArchive.Run();
                end;
            }
            action(RequiresMyApprovalTimeSheets)
            {
                ApplicationArea = Jobs;
                Caption = 'Requires My Approval';
                Image = FilterLines;
                ToolTip = 'Show just Time Sheets which requires my approval.';
                Visible = TimeSheetAdminActionsVisible;

                trigger OnAction()
                begin
                    Rec.SetRange("Approver User ID", UserId());
                    CurrPage.Update(false);
                end;
            }
        }
        area(navigation)
        {
            group("&Time Sheet")
            {
                Caption = '&Time Sheet';
                Image = Timesheet;
                action(Comments)
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Time Sheet Comment Sheet";
                    RunPageLink = "No." = field("No."),
                                  "Time Sheet Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
                action("Posting E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Posting E&ntries';
                    Image = PostingEntries;
                    RunObject = Page "Time Sheet Posting Entries";
                    RunPageLink = "Time Sheet No." = field("No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the resource ledger entries that have been posted in connection with the.';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Edit Time Sheet_Promoted"; "Edit Time Sheet")
                {
                }
                actionref(MoveTimeSheetsToArchive_Promoted; MoveTimeSheetsToArchive)
                {
                }
                actionref(RequiresMyApprovalTimeSheets_Promoted; RequiresMyApprovalTimeSheets)
                {
                }
                actionref(Comments_Promoted; Comments)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateResourceName2();
        TimeSheetAdminActionsVisible := true;
        if UserSetup.Get(UserId) then
            CurrPage.Editable := UserSetup."Time Sheet Admin.";
        TimeSheetAdminActionsVisible := UserSetup."Time Sheet Admin.";

        TimeSheetMgt.FilterTimeSheets(Rec, Rec.FieldNo("Approver User ID"));

        OnAfterOnOpenPage(Rec);
        Usersetup.GET(UserId);
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        IF Usersetup."Project manager" THEN
            Rec.SETRANGE(Rec."Approver User ID", Usersetup."User ID")
    end;

    local procedure ReviewTimeSheet()
    var
        TimeSheetCard: Page "Time Sheet Card - 15D";
    begin
        TimeSheetCard.SetManagerTimeSheetMode();
        TimeSheetCard.SetTableView(Rec);
        TimeSheetCard.SetRecord(Rec);
        TimeSheetCard.Run();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ArchiveEnabled := Rec."Posted Exists";
    end;

    var
        UserSetup: Record "User Setup";
        TimeSheetMgt: Codeunit "Time Sheet Management";
        TimeSheetAdminActionsVisible: Boolean;
        ArchiveEnabled: Boolean;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnOpenPage(var TimeSheetHeader: Record "Time Sheet Header")
    begin
    end;

    local procedure UpdateResourceName2()
    var
        Res: Record Resource;
        TimesheetHdr: Record "Time Sheet Header";
    begin
        TimesheetHdr.Reset();
        TimesheetHdr.SetRange("Resource Name 2", '');
        If TimesheetHdr.findset then
            repeat
                IF Res.get(TimesheetHdr."Resource No.") THEN begin
                    TimesheetHdr."Resource Name 2" := res.Name;
                    TimesheetHdr.Modify();
                end;
            until TimesheetHdr.next = 0;

    end;
}

