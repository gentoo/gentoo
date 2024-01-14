# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Erlang Portmapper Daemon"
ACCT_USER_ID=335
ACCT_USER_GROUPS=( epmd )

acct-user_add_deps
