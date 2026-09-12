# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="ClickHouse database server user"
ACCT_USER_ID=564
ACCT_USER_GROUPS=( clickhouse )
acct-user_add_deps
