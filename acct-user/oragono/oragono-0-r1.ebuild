# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the Oragono IRC server"
ACCT_USER_ID=324
ACCT_USER_GROUPS=( oragono )

acct-user_add_deps
