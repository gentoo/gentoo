# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Buildbot program user"
ACCT_USER_ID=393
ACCT_USER_GROUPS=( buildbot )
acct-user_add_deps
SLOT="0"
