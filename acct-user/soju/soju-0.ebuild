# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the net-irc/soju IRC bouncer"
ACCT_USER_ID=526
ACCT_USER_HOME=/var/lib/soju
ACCT_USER_HOME_PERMS=0755
ACCT_USER_GROUPS=( soju )

acct-user_add_deps
