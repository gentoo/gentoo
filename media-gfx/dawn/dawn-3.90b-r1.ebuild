# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver toolchain-funcs

MY_P=${PN}_$(ver_rs 1 _)

DESCRIPTION="3D geometrical postscript renderer"
HOMEPAGE="http://geant4.kek.jp/~tanaka/DAWN/About_DAWN.html"
SRC_URI="http://geant4.kek.jp/~tanaka/src/${MY_P}.tgz"

LICENSE="public-domain"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE="doc opengl X"

RDEPEND="dev-lang/tk:*
	opengl? ( virtual/opengl )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	app-shells/tcsh
	doc? ( virtual/latex-base )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-no-interactive.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

DOCS=( README.txt )

src_prepare() {
	default

	sed -i -e "s/\$(LIB_DIR)/\$(LDFLAGS) &/" \
		-e '/strip/d' Makefile*in || die

	if use X; then
		mv -f configure_xwin configure || die
	fi

	tc-export CXX
}

src_install() {
	dodir /usr/bin

	if use doc; then
		pdflatex DOC/G4PRIM_FORMAT_24.tex || die "pdf generation failed"
		DOCS+=( DOC/*.pdf )
		HTML_DOCS=( DOC/*.html )
	fi

	default
}
