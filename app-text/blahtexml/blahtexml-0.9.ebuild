# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="TeX-to-MathML converter"
HOMEPAGE="http://gva.noekeon.org/blahtexml"
SRC_URI="http://gva.noekeon.org/${PN}/${P}-src.tar.gz"

LICENSE="BSD CC-BY-3.0 ZLIB"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86"
IUSE="doc"

RDEPEND="dev-libs/xerces-c"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/texlive-core
		dev-libs/libxslt
		dev-tex/latex2html
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-{Makefile,gcc-4.7}.patch
)

src_prepare() {
	default

	tc-export CC CXX PKG_CONFIG
}

src_compile() {
	emake blahtex{,ml}-linux
	use doc && emake doc
}

src_install() {
	dobin blahtex ${PN}
	doman "${FILESDIR}"/${PN}.1
	use doc && dodoc Documentation/manual.pdf
}
