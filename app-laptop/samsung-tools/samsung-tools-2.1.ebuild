# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit fdo-mime python-r1

DESCRIPTION="Tools for Samsung laptops"
HOMEPAGE="http://launchpad.net/samsung-tools"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-laptop/easy-slow-down-manager
	dev-python/dbus-python
	dev-python/notify-python
	dev-python/pygtk
	net-wireless/rfkill
	sys-apps/vbetool
	sys-power/pm-utils
	x11-misc/xbindkeys"
RDEPEND="${DEPEND}"

src_compile() {
	return
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/${PN}.init ${PN}
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
