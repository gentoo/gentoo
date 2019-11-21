# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Graylog program user"
ACCT_USER_ID=478
ACCT_USER_GROUPS=( graylog )
acct-user_add_deps
