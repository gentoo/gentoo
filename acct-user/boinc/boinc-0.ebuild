# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for sci-misc/boinc"
ACCT_USER_ID=352
ACCT_USER_HOME=/var/lib/${PN}
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( boinc video )

acct-user_add_deps
