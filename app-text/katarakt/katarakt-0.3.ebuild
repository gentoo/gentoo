# Copyright 1999-2025 Gentoo Authors
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
	app-text/poppler:=[qt6]
	dev-qt/qtbase:6[dbus,gui,network,widgets]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
	"${FILESDIR}/${P}-unused-dep.patch"
)

src_configure() {
	eqmake6 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install doc
	doman doc/katarakt.1
}
