# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="https://pmt.sourceforge.io/pngcrush/"
SRC_URI="mirror://sourceforge/pmt/${P}-nolib.tar.xz"

LICENSE="pngcrush"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="media-libs/libpng:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="app-arch/xz-utils"

DOCS=( ChangeLog.html )

S="${WORKDIR}"/${P}-nolib

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS} -Wall" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	einstalldocs
}
