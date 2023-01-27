# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-dns/bind"

ACCT_USER_ID=40
ACCT_USER_HOME=/etc/bind
ACCT_USER_GROUPS=( named )

acct-user_add_deps
