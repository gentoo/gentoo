# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for spiffe runtime environment"
ACCT_USER_ID=271
ACCT_USER_GROUPS=( spire )

acct-user_add_deps
