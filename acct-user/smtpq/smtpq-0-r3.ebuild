# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="queue user for smtpd"
ACCT_USER_ID=252
ACCT_USER_GROUPS=( smtpq )
ACCT_USER_HOME=/var/empty

acct-user_add_deps
