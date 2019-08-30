# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for InspIRCd server daemon"
ACCT_USER_ID=167
ACCT_USER_GROUPS=( inspircd )

acct-user_add_deps
