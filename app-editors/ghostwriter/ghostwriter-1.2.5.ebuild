# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

DESCRIPTION="A cross-platform, aesthetic, distraction-free Markdown editor"
HOMEPAGE="http://wereturtle.github.io/ghostwriter/"
SRC_URI="https://github.com/wereturtle/ghostwriter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="qt5"

DEPEND="
	qt5? (
		dev-qt/qtprintsupport:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtconcurrent:5
	)
	!qt5? ( dev-qt/qtwebkit:4 )
"
RDEPEND="${DEPEND}"

src_compile() {
	if use qt5; then
		eqmake5 "PREFIX=/usr"
	else
		eqmake4 "PREFIX=/usr"
	fi
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
