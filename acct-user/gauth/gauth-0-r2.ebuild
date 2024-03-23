# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-auth/google-authenticator-wrappers"

ACCT_USER_GROUPS=( "gauth" )
ACCT_USER_ID="138"

acct-user_add_deps
