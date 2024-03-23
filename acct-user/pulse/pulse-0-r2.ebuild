# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for running the PulseAudio daemon as a system-wide instance"
ACCT_USER_ID=171
ACCT_USER_GROUPS=( pulse audio )
ACCT_USER_HOME=/var/run/pulse

acct-user_add_deps
