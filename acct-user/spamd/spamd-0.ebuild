# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the SpamAssassin daemon"

ACCT_USER_ID=337
ACCT_USER_GROUPS=( "${PN}" )
# The spamd daemon runs as this user. Use a real home directory so
# that it can hold SA configuration.
#
# Since spamd's home contains user-modifiable config files, it's
# a violation of the Linux FHS for it to be here, but it's been
# decided it can't be in /home/.
#
# - https://github.com/gentoo/gentoo/pull/14055#issuecomment-582929503
# - https://archives.gentoo.org/gentoo-dev/message/790294f7a46496aecd0056289c4b6d08
#
ACCT_USER_HOME="/var/lib/spamd"
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
