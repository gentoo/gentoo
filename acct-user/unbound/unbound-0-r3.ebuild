# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="unbound program user"

ACCT_USER_ID=391
ACCT_USER_HOME="/etc/${PN}"
ACCT_USER_HOME_OWNER="root:${PN}"
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
