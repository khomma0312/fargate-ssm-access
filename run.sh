#!/bin/bash
# 変数はECS起動時や、docker run時に同じ名前で渡す
amazon-ssm-agent -register -code "${SSM_AGENT_CODE}" -id "${SSM_AGENT_ID}" -region "${AWS_DEFAULT_REGION}"
amazon-ssm-agent &
httpd-foreground