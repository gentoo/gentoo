# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="uid for net-analyzer/sancp"
ACCT_USER_ID=382
ACCT_USER_GROUPS=( sancp )

acct-user_add_deps
