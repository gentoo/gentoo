# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Elasticsearch program user"
ACCT_USER_ID=183
ACCT_USER_HOME=/usr/share/elasticsearch
ACCT_USER_HOME_PERMS=0755
ACCT_USER_GROUPS=( elasticsearch )
acct-user_add_deps
