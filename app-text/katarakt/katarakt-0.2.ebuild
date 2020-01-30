# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Simple PDF viewer"
HOMEPAGE="https://gitlab.cs.fau.de/Qui_Sum/katarakt"
SRC_URI="https://gitlab.cs.fau.de/Qui_Sum/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig"
RDEPEND="
	app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-v${PV}"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
	"${FILESDIR}/${P}-poppler.patch"
)

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	emake doc
	doman doc/katarakt.1
}
