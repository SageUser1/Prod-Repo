namespace CustObjectsPerm;

using Microsoft.Purchases.Reports;
using Microsoft.Projects.TimeSheet;

permissionset 50000 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "Acc. Catg. CompQ" = RIMD,
        tabledata "Email Bodies" = RIMD,
        tabledata "Resource Category" = RIMD,
        tabledata "Sub-Con Invoice" = RIMD,
        tabledata "Sub-Con Invoice Processed" = RIMD,
        tabledata "Vendor Type" = RIMD,
        table "Acc. Catg. CompQ" = X,
        table "Email Bodies" = X,
        table "Resource Category" = X,
        table "Sub-Con Invoice" = X,
        table "Sub-Con Invoice Processed" = X,
        table "Vendor Type" = X,
        report "Aged Accounts Payable - Email" = X,
        report "Before Post Voucher-CompQ" = X,
        report "Commercial Project-CompQ" = X,
        report "Create Time Sheets - 15 Days" = X,
        report "Customer Report - CompQ" = X,
        report "Posted Voucher-CompQ" = X,
        report "Purchase Orde - CompQ" = X,
        report "Purchase Orde SubCOn - CompQ" = X,
        codeunit BaseCUSubsc = X,
        codeunit "Job Module Customs" = X,
        codeunit "SendAutoEmails-CompQ" = X,
        page "Account Category CompQ" = X,
        page "Email Body Setup" = X,
        page "Manager Time Sheet List - 15D" = X,
        page "Resource Category" = X,
        page "Sub-Con Invoices" = X,
        page "Sub-Con Invoices Processed" = X,
        page "Time Sheet Card - 15D" = X,
        page "Time Sheet Line List - 15D" = X,
        page "Time Sheet Lines - 15D" = X,
        page "Time Sheet List - 15D" = X,
        page "Vendor Type" = X,
        page "Yearly Lookup" = X,
        tabledata "Owing Organisation" = RIMD,
        tabledata "PTO Details" = RIMD,
        table "Owing Organisation" = X,
        table "PTO Details" = X,
        page "Leave Management" = X,
        page "Owing Organisation" = X,
        tabledata "Employee Salary Details" = RIMD,
        table "Employee Salary Details" = X,
        page "Employee Salary Details" = X;
}