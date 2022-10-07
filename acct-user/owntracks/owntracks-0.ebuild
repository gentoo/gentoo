# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for sci-geosciences/owntracks-recorder"
ACCT_USER_ID=524
ACCT_USER_GROUPS=( owntracks )

acct-user_add_deps
