# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for dev-db/powa-web"

ACCT_USER_ID="560"
ACCT_USER_GROUPS=( "powa" )

acct-user_add_deps
