# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-admin/tenshi"

ACCT_USER_GROUPS=( "tenshi" )
ACCT_USER_HOME="/var/lib/tenshi"
ACCT_USER_ID="283"

acct-user_add_deps
