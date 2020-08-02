# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for the glance openstack service"
ACCT_USER_ID=443
ACCT_USER_HOME=/var/lib/glance
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( glance )

acct-user_add_deps
