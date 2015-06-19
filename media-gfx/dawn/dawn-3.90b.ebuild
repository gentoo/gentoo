# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/dawn/dawn-3.90b.ebuild,v 1.6 2011/02/13 12:41:37 armin76 Exp $

EAPI=2
inherit eutils toolchain-funcs versionator

MYP=${PN}_$(replace_version_separator 1 _)

DESCRIPTION="3D geometrical postscript renderer"
HOMEPAGE="http://geant4.kek.jp/~tanaka/DAWN/About_DAWN.html"
SRC_URI="http://geant4.kek.jp/~tanaka/src/${MYP}.tgz"

LICENSE="public-domain"
SLOT="0"

KEYWORDS="amd64 hppa ppc x86"
IUSE="doc opengl X"

RDEPEND="dev-lang/tk
	X? ( x11-libs/libX11 )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	app-shells/tcsh
	doc? ( virtual/latex-base )"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-interactive.patch
	sed -i -e "s/\$(LIB_DIR)/\$(LDFLAGS) &/" \
		-e '/strip/d' Makefile*in || die
}

src_compile() {
	tc-export CXX
	emake clean
	emake guiclean
	if use X; then
		./configure_xwin || die
	else
		./configure || die
	fi
	einfo "Compiling"
	emake || die
}

src_install() {
	dodir /usr/bin
	emake DESTDIR="${D}" install || die
	dodoc README.txt
	if use doc; then
		pdflatex DOC/G4PRIM_FORMAT_24.tex || die "pdf generation failed"
		insinto /usr/share/doc/${PF}
		doins DOC/G4PRIM_FORMAT_24.pdf
		dohtml DOC/*.html
	fi
}
