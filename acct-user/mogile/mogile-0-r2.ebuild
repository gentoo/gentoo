# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="MogileFS user"
ACCT_USER_ID=460
ACCT_USER_ENFORCE_ID=1
ACCT_USER_GROUPS=( mogile )

acct-user_add_deps
