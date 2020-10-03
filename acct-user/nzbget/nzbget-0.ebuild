# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-nntp/nzbget"
ACCT_USER_ID=398
ACCT_USER_GROUPS=( ${PN} )
# Downloads are stored there
ACCT_USER_HOME=/var/lib/nzbget
# Grant write access to group members
ACCT_USER_HOME_PERMS=0770

acct-user_add_deps
