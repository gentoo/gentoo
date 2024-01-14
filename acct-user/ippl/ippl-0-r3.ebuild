# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for net-analyzer/ippl"
ACCT_USER_ID=465
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
