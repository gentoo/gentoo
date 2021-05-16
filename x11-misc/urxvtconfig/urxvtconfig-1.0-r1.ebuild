# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=URXVTConfig
inherit qmake-utils

DESCRIPTION="GUI configuration tool for the rxvt-unicode terminal emulator"
HOMEPAGE="https://github.com/daedreth/URXVTConfig"
SRC_URI="https://github.com/daedreth/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-terms/rxvt-unicode[xft]
"
DEPEND="${RDEPEND}
	media-gfx/imagemagick
	media-libs/fontconfig
	x11-libs/libXft
"

src_configure() {
	eqmake5 source/URXVTConfig.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
