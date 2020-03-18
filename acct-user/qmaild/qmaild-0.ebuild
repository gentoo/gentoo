# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for qmail-smtpd"
ACCT_USER_ID=201
ACCT_USER_GROUPS=( nofiles )

acct-user_add_deps
