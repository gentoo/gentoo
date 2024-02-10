# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Port from an old Amiga game"
HOMEPAGE="https://methane.sourceforge.net/"
SRC_URI="https://github.com/rombust/Methane/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://src.fedoraproject.org/rpms/methane/raw/f37/f/methane.png
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/Methane-${PV}"

RDEPEND="
	dev-games/clanlib:4.1[opengl,sound]
	media-libs/libmikmod
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
)

src_prepare() {
	default

	tc-export PKG_CONFIG
}

src_install() {
	dobin methane

	insinto /usr/share/${PN}
	doins resources/*

	doicon "${DISTDIR}/${PN}.png"
	make_desktop_entry ${PN} "Super Methane Brothers"
	HTML_DOCS="docs/*" dodoc authors.txt history.txt readme.txt
}
