# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Small and simple library for loading and writing PNG images"
HOMEPAGE="https://sourceforge.net/projects/pnglite/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-include-stdio.patch
)

S=${WORKDIR}

src_prepare() {
	default
	sed -ie "s:\"../zlib/zlib.h\":<zlib.h>:" pnglite.c || die
}

src_compile() {
	tc-export CC
	append-flags -fPIC
	emake ${PN}.o
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname,lib${PN}.so.0 \
		-o lib${PN}.so.0 ${PN}.o -lz || die
}

src_install() {
	insinto /usr/include
	doins ${PN}.h

	dolib.so lib${PN}.so.0
	dosym lib${PN}.so.0 /usr/$(get_libdir)/lib${PN}.so
}
