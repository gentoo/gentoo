# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for the keystone openstack service"
ACCT_USER_ID=445
ACCT_USER_HOME=/var/lib/keystone
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( keystone )

acct-user_add_deps
