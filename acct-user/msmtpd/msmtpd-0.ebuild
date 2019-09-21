# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for msmtp daemon"
ACCT_USER_ID=222
ACCT_USER_GROUPS=( msmtpd )

acct-user_add_deps
