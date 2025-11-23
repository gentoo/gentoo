# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Graphics extensions library for SDL"
HOMEPAGE="http://www.etek.chalmers.se/~e8cal1/sge/"
SRC_URI="http://www.etek.chalmers.se/~e8cal1/sge/files/sge${PV}.tar.gz"
S=${WORKDIR}/sge${PV}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples image truetype"

DEPEND="
	media-libs/libsdl
	image? ( media-libs/sdl-image )
	truetype? ( >=media-libs/freetype-2 )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-freetype.patch
	"${FILESDIR}"/${P}-cmap.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
)

src_prepare() {
	default
	sed "s:\$(PREFIX)/lib:\$(PREFIX)/$(get_libdir):" -i Makefile || die
	sed -e '/^CC=/d' -e '/^CXX=/d' -e '/^AR=/d' -i Makefile.conf || die
	# make sure the header gets regenerated every time
	rm -f sge_config.h
}

src_compile() {
	tc-export CC CXX AR PKG_CONFIG
	emake \
		USE_IMG=$(usex image y n) \
		USE_FT=$(usex truetype y n)
}

src_install() {
	local DOCS=( README Todo WhatsNew )
	default

	if use doc ; then
		docinto html
		dodoc docs/*
	fi

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -type f -name '*.a' -delete || die
}
