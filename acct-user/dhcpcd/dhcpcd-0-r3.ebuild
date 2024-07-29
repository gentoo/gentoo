# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for dhcpcd client"
ACCT_USER_ID=303
ACCT_USER_GROUPS=( dhcpcd )
ACCT_USER_HOME="/var/chroot/dhcpcd"

acct-user_add_deps
