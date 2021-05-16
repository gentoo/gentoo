# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for virtualbox-guest-additions"
ACCT_USER_ID=305
ACCT_USER_GROUPS=( vboxguest )
ACCT_USER_SHELL="/bin/sh"

acct-user_add_deps
