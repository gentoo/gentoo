# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=330
ACCT_USER_GROUPS=( ossec )
ACCT_USER_HOME=/var/ossec
DESCRIPTION="net-analyzer/ossec-hids (agentlessd, analysisd, monitord)"

acct-user_add_deps
