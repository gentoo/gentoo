# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-apps/tt-rss"
ACCT_USER_ID=386
ACCT_USER_GROUPS=( ttrssd )

acct-user_add_deps
