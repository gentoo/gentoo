# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-p2p/amule"

ACCT_USER_GROUPS=( "amule" )
ACCT_USER_HOME="/var/lib/amule"
ACCT_USER_ID="468"

acct-user_add_deps
