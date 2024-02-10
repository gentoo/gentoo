# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DOCS_BUILDER="sphinx"
DOCS_DIR="doc/user-manual"
DOCS_AUTODOC=0

inherit meson python-any-r1 docs

MY_P=${P/_/-}

DESCRIPTION="Lua interactive shell for sci-libs/gsl"
HOMEPAGE="https://www.nongnu.org/gsl-shell/"
SRC_URI="https://github.com/franko/gsl-shell/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=sci-libs/gsl-1.14:=
	virtual/blas[eselect-ldso]
	>=x11-libs/agg-2.5[X]
	>=media-libs/freetype-2.4.10
	sys-libs/readline:0=
	|| ( media-fonts/ubuntu-font-family media-fonts/freefont media-fonts/dejavu )
	x11-libs/fox:1.7
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/luajit
	virtual/pkgconfig
	doc? ( virtual/latex-base )
"

PATCHES=(
	"${FILESDIR}/${P}-no-fetching.patch"
)

src_compile() {
	meson_src_compile
	docs_compile
}
