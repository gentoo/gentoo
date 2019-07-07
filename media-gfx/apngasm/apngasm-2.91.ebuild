# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="create an APNG from multiple PNG files"
HOMEPAGE="https://sourceforge.net/projects/apngasm/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="ZLIB 7z? ( LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="7z zopfli"

RDEPEND="media-libs/libpng:0=[apng]
	sys-libs/zlib
	zopfli? ( app-arch/zopfli:= )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default

	# remove bundled libs
	rm -r zopfli zlib libpng || die

	if use 7z; then
		append-cflags -DFEATURE_7ZIP
	else
		sed -i '/^SRC_DIRS\s\+=/s/7z//' Makefile || die
	fi

	if use zopfli; then
		append-cflags -DFEATURE_ZOPFLI
		sed -i '/^LIBS\s\+=/s/$/ -lzopfli/' Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
