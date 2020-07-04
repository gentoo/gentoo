# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for OpenDKIM"

ACCT_USER_ID=334
ACCT_USER_GROUPS=( opendkim )

acct-user_add_deps
