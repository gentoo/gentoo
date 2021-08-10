# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the Sagan log monitoring system"
ACCT_USER_ID=317
ACCT_USER_GROUPS=( sagan )

acct-user_add_deps
