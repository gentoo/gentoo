# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for vpopmail"
ACCT_USER_ID=89
ACCT_USER_HOME=/var/vpopmail
ACCT_USER_GROUPS=( vpopmail )

acct-user_add_deps
