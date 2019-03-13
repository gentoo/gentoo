# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

MY_PN=URXVTConfig

DESCRIPTION="GUI configuration tool for the rxvt-unicode terminal emulator"
HOMEPAGE="https://github.com/daedreth/URXVTConfig"
SRC_URI="https://github.com/daedreth/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
LICENSE="GPL-3"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	x11-terms/rxvt-unicode[xft]"
DEPEND="${RDEPEND}
	media-gfx/imagemagick
	x11-libs/libXft
	media-libs/fontconfig"

src_configure() {
	eqmake5 source/URXVTConfig.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
