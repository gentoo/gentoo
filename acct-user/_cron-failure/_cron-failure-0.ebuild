# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sys-process/systemd-cron failure emails"
ACCT_USER_ID="520"
ACCT_USER_GROUPS=( _cron-failure )

acct-user_add_deps
