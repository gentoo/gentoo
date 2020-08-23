# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-misc/lldpd"

ACCT_USER_ID=315
ACCT_USER_GROUPS=( lldpd )

acct-user_add_deps
