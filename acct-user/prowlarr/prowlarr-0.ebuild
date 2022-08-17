# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for prowlarr"
ACCT_USER_HOME=/var/lib/prowlarr
ACCT_USER_ID=517
ACCT_USER_GROUPS=( prowlarr )

acct-user_add_deps
