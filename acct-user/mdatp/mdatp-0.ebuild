# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit acct-user

DESCRIPTION="User for app-antivirus/mdatp"
ACCT_USER_ID=565
ACCT_USER_GROUPS=( mdatp )

acct-user_add_deps
