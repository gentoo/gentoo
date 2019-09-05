# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the system-wide net-vpn/i2pd server"
ACCT_USER_ID=470
ACCT_USER_GROUPS=( i2pd )
ACCT_USER_HOME=/var/lib/i2pd
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
