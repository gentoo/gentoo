# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for prometheus"
ACCT_USER_ID=430
ACCT_USER_GROUPS=( prometheus )
ACCT_USER_HOME=/var/lib/prometheus

acct-user_add_deps
