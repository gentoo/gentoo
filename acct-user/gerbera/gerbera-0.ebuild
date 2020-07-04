# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Gerbera UPnP Media Server user"
ACCT_USER_ID=429
ACCT_USER_HOME=/var/lib/gerbera
ACCT_USER_GROUPS=( gerbera video )

acct-user_add_deps
