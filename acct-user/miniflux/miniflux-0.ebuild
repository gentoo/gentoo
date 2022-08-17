# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-apps/miniflux"
ACCT_USER_ID=404
ACCT_USER_GROUPS=( nobody )

acct-user_add_deps
