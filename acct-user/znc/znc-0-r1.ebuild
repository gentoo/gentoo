# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-irc/znc"
ACCT_USER_ID=421
ACCT_USER_GROUPS=( ${PN} )
# The systemd unit needs HOME to be set
# https://bugs.gentoo.org/521916
ACCT_USER_HOME=/var/lib/znc
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
