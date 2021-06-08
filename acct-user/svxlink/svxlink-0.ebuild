# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the svxlink server"
ACCT_USER_ID=247
ACCT_USER_GROUPS=( svxlink )

acct-user_add_deps
