# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Ethernet program loader for the Dreamcast"
HOMEPAGE="http://cadcdev.sourceforge.net/"
SRC_URI="mirror://sourceforge/cadcdev/dcload-ip-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="sys-libs/binutils-libs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/dcload-ip-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-bfd-update.patch
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	tc-export CC
	append-cppflags -DPACKAGE -DPACKAGE_VERSION #465952
}

src_compile() {
	emake -C host-src/tool
}

src_install() {
	dobin host-src/tool/dc-tool

	dodoc README NETWORK CHANGES
	dodoc -r make-cd
	use doc && dodoc -r example-src
}
