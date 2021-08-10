# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for app-admin/logsurfer"

ACCT_USER_GROUPS=( "logsurfer" )
ACCT_USER_ID="249"

acct-user_add_deps
