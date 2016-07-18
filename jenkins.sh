#!/bin/bash
if [ ! -d terraform_plan_report ]; then
 mkdir terraform_plan_report
fi
PATH=/usr/local/src/terraform:$PATH
terraform plan > terraform.out
cat terraform.out | ./ansi2html.sh --bg=dark > terraform_plan_report/live.html
cat terraform.out | ./ansi2html.sh --bg=dark > terraform_plan_report/dev.html
# Strip CSS styling for PR update message
sed '/<style type=\"text\/css\">/,/<\/style>/d' terraform_plan_report/live.html > terraform_plan_report/pr_update.md
