# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for puppet services"
ACCT_USER_ID=455
ACCT_USER_HOME=/var/lib/puppet
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( puppet )

acct-user_add_deps
