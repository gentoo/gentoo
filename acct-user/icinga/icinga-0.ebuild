# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Icinga User"
ACCT_USER_ID=456
ACCT_USER_HOME=/var/lib/icinga2
ACCT_USER_GROUPS=( icinga icingacmd nagios )

acct-user_add_deps
