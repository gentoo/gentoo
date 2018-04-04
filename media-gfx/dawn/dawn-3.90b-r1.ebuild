# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs versionator

MYP=${PN}_$(replace_version_separator 1 _)

DESCRIPTION="3D geometrical postscript renderer"
HOMEPAGE="http://geant4.kek.jp/~tanaka/DAWN/About_DAWN.html"
SRC_URI="http://geant4.kek.jp/~tanaka/src/${MYP}.tgz"

LICENSE="public-domain"
SLOT="0"

KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="doc opengl X"

RDEPEND="dev-lang/tk:*
	X? ( x11-libs/libX11 )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	app-shells/tcsh
	doc? ( virtual/latex-base )"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}"/${P}-no-interactive.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_prepare() {
	default

	sed -i -e "s/\$(LIB_DIR)/\$(LDFLAGS) &/" \
		-e '/strip/d' Makefile*in || die

	if use X; then
		mv -f "${S}"/configure_xwin "${S}"/configure || die
	fi

	tc-export CXX
}

src_install() {
	dodir /usr/bin

	if use doc; then
		pdflatex DOC/G4PRIM_FORMAT_24.tex || die "pdf generation failed"
		DOCS=( README.txt DOC/*.pdf )
		HTML_DOCS=( DOC/*.html )
	fi

	default
}
