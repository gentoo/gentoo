# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=65534
ACCT_USER_ENFORCE_ID=yes
ACCT_USER_HOME="/var/empty"
ACCT_USER_HOME_OWNER="root:root"
ACCT_USER_HOME_PERMS=0755
ACCT_USER_GROUPS=( nobody )

acct-user_add_deps

RDEPEND+=" acct-user/root"
