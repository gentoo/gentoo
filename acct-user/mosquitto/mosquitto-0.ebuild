# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the mosquitto MQTT broker"
ACCT_USER_ID=482
ACCT_USER_GROUPS=( mosquitto )

acct-user_add_deps
