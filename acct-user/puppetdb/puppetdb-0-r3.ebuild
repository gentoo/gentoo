# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the puppetdb service"
ACCT_USER_ID=456
ACCT_USER_HOME=/opt/puppetlabs/server/data/puppetserver
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( puppetdb )

acct-user_add_deps
