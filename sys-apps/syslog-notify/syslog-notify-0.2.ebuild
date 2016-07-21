# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit readme.gentoo

DESCRIPTION="Notifications for syslog entries via libnotify"
HOMEPAGE="https://jtniehof.github.com/syslog-notify/"
SRC_URI="mirror://github/jtniehof/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=x11-libs/libnotify-0.7"
RDEPEND="${DEPEND}
	|| ( app-admin/syslog-ng app-admin/rsyslog )"

pkg_setup() {
	DOCS="AUTHORS CHANGELOG HACKING README"
	DISABLE_AUTOFORMATTING="yes"
	DOC_CONTENTS="Add the following options on your /etc/syslog-ng/syslog-ng.conf
file:
#  destination notify { pipe("/var/spool/syslog-notify"); };
#  log { source(src); destination(notify);};

Remember to restart syslog-ng before starting syslog-notify."
}

src_install() {
	default
	dodir /var/spool
	readme.gentoo_create_doc
}

pkg_postinst() {
	mkfifo "${EROOT}"/var/spool/syslog-notify
	readme.gentoo_print_elog
}
