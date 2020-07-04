# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib toolchain-funcs

MY_P="sge${PV}"
DESCRIPTION="Graphics extensions library for SDL"
HOMEPAGE="http://www.etek.chalmers.se/~e8cal1/sge/"
SRC_URI="http://www.etek.chalmers.se/~e8cal1/sge/files/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
IUSE="doc examples image truetype"

RDEPEND="media-libs/libsdl
	image? ( media-libs/sdl-image )
	truetype? ( >=media-libs/freetype-2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-freetype.patch
	"${FILESDIR}"/${P}-cmap.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
)

src_prepare() {
	default
	sed -i "s:\$(PREFIX)/lib:\$(PREFIX)/$(get_libdir):" Makefile || die
	sed -i \
		-e '/^CC=/d' \
		-e '/^CXX=/d' \
		-e '/^AR=/d' \
		Makefile.conf || die
	tc-export CC CXX AR
	# make sure the header gets regenerated everytime
	rm -f sge_config.h
}

src_compile() {
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

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
