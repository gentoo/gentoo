# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="uid for net-analyzer/sancp"
ACCT_USER_ID=382
ACCT_USER_GROUPS=( sancp )

acct-user_add_deps
