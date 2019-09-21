# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Kibana program user"
ACCT_USER_ID=269
ACCT_USER_HOME=/var/lib/kibana
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( kibana )
acct-user_add_deps
