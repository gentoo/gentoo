# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Makeself archive extractor"
HOMEPAGE="https://www.freshports.org/archivers/unmakeself"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-arch/libarchive:=[bzip2,zlib]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags libarchive)
	export LDLIBS=$($(tc-getPKG_CONFIG) --libs libarchive)

	tc-export CC
}

src_compile() {
	emake ${PN}
}

src_install() {
	dobin unmakeself
}
