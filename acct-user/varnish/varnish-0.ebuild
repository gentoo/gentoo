# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for varnish"
ACCT_USER_ID=474
ACCT_USER_GROUPS=( varnish )
ACCT_USER_HOME=/var/lib/varnish
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
