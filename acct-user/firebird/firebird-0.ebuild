# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-dialup/mgetty"

ACCT_USER_GROUPS=( "firebird" )
ACCT_USER_HOME="/usr/$(get_libdir)/firebird"
ACCT_USER_ID="520"
ACCT_USER_SHELL="/bin/sh"

acct-user_add_deps
