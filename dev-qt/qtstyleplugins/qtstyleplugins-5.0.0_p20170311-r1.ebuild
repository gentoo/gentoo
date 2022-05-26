# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

COMMIT="335dbece103e2cbf6c7cf819ab6672c2956b17b3"
DESCRIPTION="Additional style plugins for Qt5 (gtk2, cleanlook, plastic, motif)"
HOMEPAGE="https://code.qt.io/cgit/qt/qtstyleplugins.git/"
SRC_URI="https://github.com/qt/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=[dbus]
	dev-qt/qtwidgets:5=
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
"

RDEPEND="
	${DEPEND}
"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/fix-build-qt5.15.patch
)

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	elog "To make Qt5 use the gtk2 style, set this in your environment:"
	elog "  QT_QPA_PLATFORMTHEME=gtk2"
}
