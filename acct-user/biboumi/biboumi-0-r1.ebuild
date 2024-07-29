# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-im/biboumi"
ACCT_USER_ID=508
ACCT_USER_GROUPS=( biboumi )

acct-user_add_deps
