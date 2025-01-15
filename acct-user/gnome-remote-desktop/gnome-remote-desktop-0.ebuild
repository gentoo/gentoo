# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for running gnome-remote-desktop"

ACCT_USER_ID=545
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME=/var/lib/gnome-remote-desktop

acct-user_add_deps
