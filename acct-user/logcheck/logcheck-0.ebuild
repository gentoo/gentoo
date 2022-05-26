# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for app-admin/logcheck"

ACCT_USER_GROUPS=( "logcheck" )
ACCT_USER_ID="284"

acct-user_add_deps
