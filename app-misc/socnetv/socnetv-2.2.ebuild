# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils toolchain-funcs

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="https://socnetv.org/"
SRC_URI="mirror://sourceforge/socnetv/SocNetV-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
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
