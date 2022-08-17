# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Cross-platform, aesthetic, distraction-free markdown editor"
HOMEPAGE="https://wereturtle.github.io/ghostwriter/"
SRC_URI="https://github.com/wereturtle/ghostwriter/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

BDEPEND="dev-qt/linguist-tools:5"

RDEPEND="
	app-text/hunspell:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	virtual/opengl
"

DEPEND="${RDEPEND}"

DOCS=( CREDITS.md README.md )

src_configure() {
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
