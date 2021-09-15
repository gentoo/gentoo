# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for dev-util/artifactory-bin"

ACCT_USER_GROUPS=( "artifactory" )
ACCT_USER_ID="264"
ACCT_USER_SHELL="/bin/sh"

acct-user_add_deps
