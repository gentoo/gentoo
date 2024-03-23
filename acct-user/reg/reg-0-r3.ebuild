# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit acct-user

DESCRIPTION="A user for app-containers/reg"

ACCT_USER_ID=503
ACCT_USER_GROUPS=( reg )
ACCT_USER_HOME=/var/lib/reg

acct-user_add_deps
