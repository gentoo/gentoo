# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="The user used by dev-build/steve"
ACCT_USER_ID=555
ACCT_USER_GROUPS=( steve cuse )

acct-user_add_deps
