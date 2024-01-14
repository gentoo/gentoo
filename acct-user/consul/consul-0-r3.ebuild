# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for consul"
ACCT_USER_HOME=/var/lib/consul
ACCT_USER_ID=411
ACCT_USER_GROUPS=( consul )

acct-user_add_deps
