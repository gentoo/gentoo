# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A group for the bacula backup system"
ACCT_USER_ID=273
ACCT_USER_HOME=/var/lib/bacula
ACCT_USER_GROUPS=( bacula disk tape cdrom )

acct-user_add_deps
