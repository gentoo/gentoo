# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit versionator latex-package

MY_P="${PN}$(version_format_string '$1-$2')"

DESCRIPTION="LaTeX2e macros for journals of the American Physical Society and the American Institute of Physics"
HOMEPAGE="http://authors.aps.org/revtex4/"

SRC_URI="http://authors.aps.org/revtex4/${MY_P}.zip -> ${P}.zip"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-texlive/texlive-latex-2012"
DEPEND="app-arch/unzip"

IUSE="doc"

S="${WORKDIR}/${MY_P}"

TEXMF=/usr/share/texmf-site
# Bug #574350
LATEX_PACKAGE_SKIP="reftest4-1.tex 00readme.tex aip.dtx ltxgrid.dtx ltxdocext.dtx"

src_unpack() {
	default
	cd "${S}"
	unzip -o -j "${S}/${MY_P}-tds.zip"
}

src_install() {
	latex-package_src_install

	# we need the revtex-specific rtx files in the same dir as the class files
	insinto ${TEXMF}/tex/latex/${PN}
	for i in `find . -maxdepth 1 -type f -name "*.rtx"` ; do
		doins $i || die "doins $i failed"
	done
}
