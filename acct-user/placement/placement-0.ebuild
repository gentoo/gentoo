# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the placement openstack service"
ACCT_USER_ID=448
ACCT_USER_HOME=/var/lib/placement
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( placement )

acct-user_add_deps
