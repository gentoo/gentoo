# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="uid for net-analyzer/darkstat"
ACCT_USER_ID=380
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
