# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Snapcast client component"
ACCT_USER_ID=115
ACCT_USER_HOME=/var/lib/snapclient
ACCT_USER_HOME_OWNER=snapclient:audio
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( audio )

acct-user_add_deps
