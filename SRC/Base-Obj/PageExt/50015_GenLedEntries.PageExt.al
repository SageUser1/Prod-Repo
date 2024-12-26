pageextension 50015 GenledgEntrExt extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Dimensions)
        {
            action(Print)
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    GenLedEntries: Record "G/L Entry";
                begin
                    GenLedEntries.Reset();
                    GenLedEntries.SetRange("Document No.", rec."Document No.");
                    if GenLedEntries.FindFirst() then
                        Report.RunModal(50004, True, False, GenLedEntries);
                end;
            }
            action(Send)
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Send email';
                ToolTip = 'Send the email.';
                ApplicationArea = All;
                Image = SendMail;

                trigger OnAction()
                var
                    TheMessage: Codeunit "Email Message";
                    UserSetup: Record "User Setup";
                    email: Codeunit Email;
                    ToId: list of [text];
                    AttachtempBlob: Codeunit "Temp Blob";
                    Instream: InStream;
                    Outstream: OutStream;
                    Filemgt: Codeunit "File Management";
                    RecRefer: RecordRef;
                    RecrdID: RecordId;
                    EmailBodySetup: Record "Email Bodies";
                    GenLedEntries: Record "G/L Entry";
                    BaseCUSub: Codeunit BaseCUSubsc;
                begin
                    Clear(ToId);
                    UserSetup.Reset();
                    UserSetup.SetRange("Gen Led Entries Email", true);
                    IF UserSetup.FindFirst() THEN BEGIN
                        repeat
                            UserSetup.TestField("E-Mail");
                            ToId.add(UserSetup."E-Mail");
                        until UserSetup.Next() = 0;

                        GenLedEntries.Reset();
                        CurrPage.SetSelectionFilter(GenLedEntries);
                        IF GenLedEntries.FINDSET then
                            repeat
                                RecRefer.GetTable(GenLedEntries);
                                EmailBodySetup.RESET;
                                EmailBodySetup.SetRange(Type, EmailBodySetup.Type::"General Ledger Entries");
                                IF Not EmailBodySetup.FindLast() then
                                    Error('Email body setup not done for General Ledger Entries.');
                                TheMessage.Create(ToId, 'Posted Voucher Details', StrSubstNo(EmailBodySetup."Email Editor", GenLedEntries."Document No."), false);
                                AttachtempBlob.CreateOutStream(Outstream);
                                //RecRef will work on Primary key...So, below report should work as per the primary key fields and if not add same dataseas main and manage.
                                Report.SaveAs(Report::"Posted Voucher-CompQ", '', ReportFormat::Pdf, Outstream, RecRefer);
                                AttachtempBlob.CreateInStream(Instream);
                                TheMessage.AddAttachment(GenLedEntries."Document No." + '.pdf', 'PDF', Instream);
                                email.Send(TheMessage);
                                Message('Mail Sent For Document No. %1', GenLedEntries."Document No.");
                            until GenLedEntries.next = 0;
                    end;
                end;
            }
        }
    }
}