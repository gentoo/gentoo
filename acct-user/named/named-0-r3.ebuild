# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-dns/bind"

ACCT_USER_ID=40
ACCT_USER_HOME=/etc/bind
ACCT_USER_GROUPS=( named )

acct-user_add_deps
