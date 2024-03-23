# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=332
ACCT_USER_GROUPS=( ossec )
DESCRIPTION="net-analyzer/ossec-hids (remoted)"

acct-user_add_deps
