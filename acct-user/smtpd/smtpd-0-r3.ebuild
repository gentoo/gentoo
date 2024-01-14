# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="daemon user for smtpd"
ACCT_USER_ID=25
ACCT_USER_GROUPS=( smtpd )
ACCT_USER_HOME=/var/empty

acct-user_add_deps
