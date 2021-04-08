# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for gofish"
ACCT_USER_ID=287
ACCT_USER_GROUPS=( gopher )

acct-user_add_deps
