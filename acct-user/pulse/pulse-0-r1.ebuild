# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for running the PulseAudio daemon as a system-wide instance"
ACCT_USER_ID=171
ACCT_USER_GROUPS=( pulse audio )
ACCT_USER_HOME=/var/run/pulse

acct-user_add_deps
