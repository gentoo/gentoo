# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Router Advertisement Daemon"

ACCT_USER_GROUPS=( "radvd" )
ACCT_USER_ID="215"

acct-user_add_deps
