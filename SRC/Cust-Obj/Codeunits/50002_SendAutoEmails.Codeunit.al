codeunit 50002 "SendAutoEmails-CompQ"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        IF Rec."Parameter String" = 'AgedAccountsPayable' then
            AgedAccountsPayable();

    end;

    procedure AgedAccountsPayable()
    var
        TheMessage: Codeunit "Email Message";
        UserSetup: Record "User Setup";
        email: Codeunit Email;
        ToId: list of [text];
        AttachtempBlob: Codeunit "Temp Blob";
        Instream: InStream;
        Outstream: OutStream;
        Filemgt: Codeunit "File Management";
        EmailBodySetup: Record "Email Bodies";
        AgedAccPayable: Report "Aged Accounts Payable";
    begin

        Clear(ToId);
        UserSetup.Reset();
        UserSetup.SetRange("Aged Acc. Payable Email", true);
        IF UserSetup.FindFirst() THEN BEGIN
            repeat
                UserSetup.TestField("E-Mail");
                ToId.add(UserSetup."E-Mail");
            until UserSetup.Next() = 0;
            EmailBodySetup.RESET;
            EmailBodySetup.SetRange(Type, EmailBodySetup.Type::"Aged Account Payable");
            IF Not EmailBodySetup.FindLast() then
                Error('Email body setup not done for Aged Account Payable.');
            TheMessage.Create(ToId, 'Aged Account Payable', StrSubstNo(EmailBodySetup."Email Editor", WorkDate()), false);
            AttachtempBlob.CreateOutStream(Outstream);
            Report.SaveAs(Report::"Aged Accounts Payable - Email", '', ReportFormat::Pdf, Outstream);
            AttachtempBlob.CreateInStream(Instream);
            TheMessage.AddAttachment('AccAgedPayable' + Format(WorkDate()) + '.pdf', 'PDF', Instream);
            email.Send(TheMessage);
        End;
    end;

    var
        myInt: Integer;
}