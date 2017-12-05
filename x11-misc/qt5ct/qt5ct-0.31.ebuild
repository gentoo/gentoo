# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Qt5 configuration tool, similar to qtconfig for Qt4"
HOMEPAGE="https://sourceforge.net/projects/qt5ct/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="+systray"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5
	systray? ( dev-qt/qtgui:5[dbus] )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

src_configure() {
	eqmake5 DEFINES="$(usex systray '' QT_NO_SYSTEMTRAYICON)" ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs

	echo 'QT_QPA_PLATFORMTHEME=qt5ct' > "${T}"/98${PN} || die
	doenvd "${T}"/98${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn "qt5ct configuration won't be applied to the currently running sessions."
		ewarn "Please relogin."
	fi
	if ! has_version 'dev-qt/qtsvg:5'; then
		elog
		elog "For SVG icon themes, please install 'dev-qt/qtsvg:5'."
		elog
	fi
}
