# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the SKS OpenPGP keyserver"
ACCT_USER_ID=370
ACCT_USER_GROUPS=( sks )

acct-user_add_deps
