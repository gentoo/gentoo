# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for consul-template"
ACCT_USER_ID=408
ACCT_USER_GROUPS=( consul-template )

acct-user_add_deps
