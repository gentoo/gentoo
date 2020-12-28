# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for chrooted scponly"
ACCT_USER_ID=239
ACCT_USER_GROUPS=( scponly )
# Not a typo.  scponly uses the trailing // to identify the chroot dir.
ACCT_USER_HOME=/var/chroot/scponly//
ACCT_USER_HOME_OWNER=root:root

acct-user_add_deps
