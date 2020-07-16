# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for qmail-rspawn and qmail-remote"
ACCT_USER_ID=205
ACCT_USER_GROUPS=( qmail )

acct-user_add_deps
