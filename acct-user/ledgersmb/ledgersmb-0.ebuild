# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="LedgerSMB Service User"
ACCT_USER_ID=525
ACCT_USER_GROUPS=( ledgersmb )

acct-user_add_deps
