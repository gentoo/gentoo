# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the www-servers/xsp dotnet server"

ACCT_USER_ID=216
ACCT_USER_GROUPS=( aspnet )

acct-user_add_deps
