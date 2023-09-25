# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DOCS_BUILDER="sphinx"
DOCS_DIR="doc/user-manual"
DOCS_AUTODOC=0
inherit toolchain-funcs python-any-r1 docs

MY_P=${P/_/-}
DESCRIPTION="Lua interactive shell for sci-libs/gsl"
HOMEPAGE="https://www.nongnu.org/gsl-shell/"
SRC_URI="https://github.com/franko/gsl-shell/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="fox"

RDEPEND="
	>=sci-libs/gsl-1.14:=
	virtual/blas
	>=x11-libs/agg-2.5
	>=media-libs/freetype-2.4.10
	sys-libs/readline:0=
	|| ( media-fonts/ubuntu-font-family media-fonts/freefont media-fonts/dejavu )
	fox? ( x11-libs/fox:1.6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/luajit
	virtual/pkgconfig
	doc? ( virtual/latex-base )
"

PATCHES=(
	"${FILESDIR}/${P}-no-compile-in-install.patch"
	"${FILESDIR}/${P}-sphinx-extmath-to-imgmath.patch"
)

src_prepare() {
	tc-export PKG_CONFIG
	default
}

src_compile() {
	local BLAS=$($(tc-getPKG_CONFIG) --libs blas)
	local GSL=$($(tc-getPKG_CONFIG) --libs gsl)
	emake -j1 gsl-shell CC="$(tc-getCC)" CXX="$(tc-getCXX)" CFLAGS="${CFLAGS}" \
		GSL_LIBS="$($(tc-getPKG_CONFIG) --libs gsl) ${BLAS}"
	if use fox; then
		local FOX_INCLUDES="$(WANT_FOX=1.6 fox-config --cflags)"
		local FOX_LIBS="$(WANT_FOX=1.6 fox-config --libs)"
		emake -j1 gsl-shell-gui CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
			CFLAGS="${CFLAGS}" FOX_INCLUDES="${FOX_INCLUDES}" FOX_LIBS="${FOX_LIBS}"  \
			GSL_LIBS="$($(tc-getPKG_CONFIG) --libs gsl) ${BLAS}"
	fi
	docs_compile
}
