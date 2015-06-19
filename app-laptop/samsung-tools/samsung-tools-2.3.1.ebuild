# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/samsung-tools/samsung-tools-2.3.1.ebuild,v 1.1 2015/06/11 00:45:02 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit fdo-mime python-single-r1

DESCRIPTION="Tools for Samsung laptops"
HOMEPAGE="http://launchpad.net/samsung-tools"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	app-laptop/easy-slow-down-manager
	net-wireless/rfkill
	sys-apps/vbetool
	sys-power/pm-utils
	x11-misc/xbindkeys"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile() {
	return
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/${PN}.init ${PN}

	python_fix_shebang "${D}"/usr/bin
	python_fix_shebang "${D}"/usr/share/samsung-tools/system-service.py
	python_fix_shebang "${D}"/usr/share/samsung-tools/session-service.py
	python_optimize "${D}"/usr/share/samsung-tools/backends
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
