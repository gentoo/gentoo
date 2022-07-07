# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-im/synapse"
ACCT_USER_ID=519
ACCT_USER_GROUPS=( synapse )

acct-user_add_deps
