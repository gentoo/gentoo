# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the system-wide net-p2p/go-ipfs-bin server"
ACCT_USER_ID=484
ACCT_USER_HOME=/var/lib/ipfs
ACCT_USER_HOME_PERMS=0755
ACCT_USER_GROUPS=( ipfs )

acct-user_add_deps
