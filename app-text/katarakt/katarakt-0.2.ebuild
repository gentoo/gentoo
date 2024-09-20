# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_P="${PN}-v${PV}"

DESCRIPTION="A simple PDF viewer designed to use as much available screen space as possible"
HOMEPAGE="https://gitlab.cs.fau.de/Qui_Sum/katarakt"
SRC_URI="https://gitlab.cs.fau.de/Qui_Sum/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig
"
RDEPEND="
	app-text/poppler:=[qt5]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
	"${FILESDIR}/${P}-poppler.patch"
)

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install doc
	doman doc/katarakt.1
}
