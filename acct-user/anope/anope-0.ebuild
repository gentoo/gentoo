# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for Anope IRC services"
ACCT_USER_ID=417
ACCT_USER_GROUPS=( anope )

acct-user_add_deps
