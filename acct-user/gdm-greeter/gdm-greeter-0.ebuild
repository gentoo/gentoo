# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for GDM greeter specialized for elogind"
ACCT_USER_ID=558
ACCT_USER_GROUPS=( gdm )
ACCT_USER_HOME=/var/lib/gdm-greeter

acct-user_add_deps
