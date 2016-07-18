#!/bin/bash
if [ ! -d terraform_plan_report ]; then
 mkdir terraform_plan_report
fi
PATH=/usr/local/src/terraform:$PATH
terraform plan > terraform.out
cat terraform.out | ./ansi2html.sh --bg=dark > terraform_plan_report/eldorado.html
cat terraform.out | ./ansi2html.sh --bg=dark > terraform_plan_report/dev.html
cat terraform.out | ./ansi2html.sh --bg=dark > terraform_plan_report/liberty.html
# Strip CSS styling for PR update message
echo "## Summary of updates for Live StepWeb B Live C environment" > terraform_plan_report/pr_update.md
grep "Plan:" terraform_plan_report/liberty.html >> terraform_plan_report/pr_update.md
echo "Full Terraform Plan can be viewed here : ${JOB_URL}/Terraform_Plans " >> terraform_plan_report/pr_update.md
