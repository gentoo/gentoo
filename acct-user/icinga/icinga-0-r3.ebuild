# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Icinga User"
ACCT_USER_ID=457
ACCT_USER_HOME=/var/lib/icinga2
ACCT_USER_GROUPS=( icinga icingacmd nagios )

acct-user_add_deps
