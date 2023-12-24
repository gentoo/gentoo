# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( cloudflared )
ACCT_USER_HOME="/etc/cloudflared"
ACCT_USER_HOME_OWNER="cloudflared:cloudflared"

acct-user_add_deps
