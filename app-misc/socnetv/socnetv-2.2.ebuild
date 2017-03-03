# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils toolchain-funcs

MY_PN="SocNetV"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="http://socnetv.sourceforge.net/"
SRC_URI="mirror://sourceforge/socnetv/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}"-deps.patch )

src_configure() {
	eqmake5 socnetv.pro
}

src_install() {
	default
	dobin socnetv
	doicon src/images/socnetv.png
	domenu ${PN}.desktop
	if use examples; then
		insinto /usr/share/${PN}/examples
		doins nets/*
	fi
	doman "${S}/man/${PN}.1.gz"
}
