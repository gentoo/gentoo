# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for openntpd daemon"
ACCT_USER_ID=321
ACCT_USER_GROUPS=( openntpd )
ACCT_USER_HOME=/var/lib/openntpd/chroot
ACCT_USER_HOME_OWNER=root:root

acct-user_add_deps
