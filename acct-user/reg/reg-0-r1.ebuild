# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit acct-user

DESCRIPTION="A user for app-emulation/reg"

ACCT_USER_ID=503
ACCT_USER_GROUPS=( reg )
ACCT_USER_HOME=/var/lib/reg

acct-user_add_deps
