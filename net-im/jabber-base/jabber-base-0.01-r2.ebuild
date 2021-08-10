# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Base layout package for various jabber services"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"

RDEPEND="
	acct-group/jabber
	acct-user/jabber
"

# This package provides the base layout for all jabber related services.
# Each service should use the user 'jabber' and the group 'jabber.
#
# The base layout contains of the following directories:
# '/etc/jabber/'	: All main configuration, by jabber services used, is stored here.
# '(/var)/run/jabber'	: All pid files, used by jabber services, are stored here.
#			: Please note, that this directory should be
#			: created dynamically by each jabber service during startup.
# '/var/log/jabber/'	: All log files, used by jabber services, are stored here.
# '/var/spool/jabber'	: All (flat) database files, used by jabber services, are stored here.

src_install() {
	local paths=(
		"/etc/jabber"
		"/var/log/jabber"
		"/var/spool/jabber"
	)

	for path in ${paths[@]}; do
		keepdir "${path}"
		fowners "jabber:jabber" "${path}"
		fperms 770 "${path}"
	done
}
