# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the usbmuxd daemon"
ACCT_USER_ID=418
ACCT_USER_GROUPS=( usb plugdev )

acct-user_add_deps
