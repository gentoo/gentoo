# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Ethernet program loader for the Dreamcast"
HOMEPAGE="https://cadcdev.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/cadcdev/dcload-ip-${PV}-src.tar.gz"
S="${WORKDIR}/dcload-ip-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sys-libs/binutils-libs"
DEPEND="${RDEPEND}"

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
