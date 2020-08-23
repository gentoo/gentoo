# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-p2p/airdcpp-webclient"
ACCT_USER_ID=464
ACCT_USER_GROUPS=( ${PN} )
# Settings are stored in $HOME
ACCT_USER_HOME=/var/lib/airdcppd
# Grant write access to group members
ACCT_USER_HOME_PERMS=0770

acct-user_add_deps
