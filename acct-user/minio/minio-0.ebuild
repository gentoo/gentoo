# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for minio"
ACCT_USER_ID=309
ACCT_USER_HOME=/var/lib/minio
ACCT_USER_GROUPS=( minio )

acct-user_add_deps
