# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P=${P/_/-}
DESCRIPTION="Lua interactive shell for sci-libs/gsl"
HOMEPAGE="http://www.nongnu.org/gsl-shell/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="doc fox"

RDEPEND="
	>=sci-libs/gsl-1.14
	virtual/blas
	>=x11-libs/agg-2.5
	>=media-libs/freetype-2.4.10
	sys-libs/readline:0=
	|| ( media-fonts/ubuntu-font-family media-fonts/freefont media-fonts/dejavu )
	fox? ( x11-libs/fox:1.6 )"
DEPEND="${DEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx[latex] )"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-font.patch
	"${FILESDIR}"/${PN}-strip.patch
	"${FILESDIR}"/${PN}-usr.patch
	"${FILESDIR}"/${PN}-2.2.0-pkg-config.patch
	"${FILESDIR}"/${P/_beta*/}-gdt-cflags.patch
)

src_prepare() {
	tc-export PKG_CONFIG
	use fox || PATCHES+=( "${FILESDIR}"/${PN}-nogui.patch )
	default
}

src_compile() {
	local BLAS=$($(tc-getPKG_CONFIG) --libs blas)

	if use fox; then
		local FOX_INCLUDES="$(WANT_FOX=1.6 fox-config --cflags)"
		local FOX_LIBS="$(WANT_FOX=1.6 fox-config --libs)"
		emake -j1 CFLAGS="${CFLAGS}" GSL_LIBS="$($(tc-getPKG_CONFIG) --libs gsl) ${BLAS}" \
			FOX_INCLUDES="${FOX_INCLUDES}" FOX_LIBS="${FOX_LIBS}"
	else
		emake -j1 CFLAGS="${CFLAGS}" GSL_LIBS="$($(tc-getPKG_CONFIG) --libs gsl) ${BLAS}"
	fi

	use doc && emake -C doc/user-manual -j1 html
}

src_install() {
	use doc && HTML_DOCS+=( doc/user-manual/_build/html/. )
	default
}
