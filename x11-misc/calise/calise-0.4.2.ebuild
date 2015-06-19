# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/calise/calise-0.4.2.ebuild,v 1.4 2015/06/09 07:05:02 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 linux-info systemd

DESCRIPTION="Computes ambient brightness and sets screen's correct backlight using a webcam"
HOMEPAGE="http://calise.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${PN}-beta/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="${RDEPEND}
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	sci-astronomy/pyephem[${PYTHON_USEDEP}]
	x11-themes/hicolor-icon-theme"
DEPEND="${CDEPEND}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	dev-util/intltool
	sys-kernel/linux-headers
	x11-libs/libX11"
RDEPEND="${CDEPEND}"

CONFIG_CHECK="~BACKLIGHT_CLASS_DEVICE"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Add missing trailing ; to desktop file.
	sed -i 's/^\(Categories=Utility\)$/\1;/' \
		share/applications/calise.desktop.in || die

	# Fix up bashisms.
	sed -i 's:&>/dev/null:2>\&1 >/dev/null:' \
		other/init_scripts/init.d/${PN}d || die
}

src_install() {
	doconfd other/init_scripts/conf.d/${PN}d
	doinitd other/init_scripts/init.d/${PN}d
	systemd_dounit other/systemd_scripts/${PN}d.service

	install -D -m755 other/pm-utils_scripts/53${PN}d "${D}"/usr/lib/pm-utils/sleep.d/53${PN}d

	distutils-r1_src_install
}

pkg_postinst() {
	einfo "Optional runtime dependency: dev-python/PyQt4 for GUI"
}
