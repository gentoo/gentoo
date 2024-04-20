# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Icinga Director User"
ACCT_USER_ID=231
ACCT_USER_HOME=/var/lib/icingadirector
ACCT_USER_GROUPS=( icingaweb2 )

acct-user_add_deps
