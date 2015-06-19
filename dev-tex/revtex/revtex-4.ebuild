# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/revtex/revtex-4.ebuild,v 1.3 2013/09/12 22:19:22 dilfridge Exp $

EAPI=5

inherit latex-package

DESCRIPTION="LaTeX2e macros for journals of the American Physical Society and the American Institute of Physics"
HOMEPAGE="http://authors.aps.org/revtex4/"

SRC_URI="http://publish.aps.org/files/revtex/4/revtex4.zip"

LICENSE="LPPL-1.3c"
SLOT="4"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-texlive/texlive-latex-2012"
DEPEND="app-arch/unzip"

IUSE=""

S="${WORKDIR}/revtex4/src"

TEXMF=/usr/share/texmf-site

src_install() {
	latex-package_src_install

	# we need the revtex-specific rtx files in the same dir as the class files
	insinto ${TEXMF}/tex/latex/${PN}
	for i in `find . -maxdepth 1 -type f -name "*.rtx"` ; do
		doins $i || die "doins $i failed"
	done

	# remove duplicate docu files to allow concurrent install with revtex-4.1
	rm -fv "${ED}/${TEXMF}/doc/latex/revtex/"{ltxdocext.pdf,ltxgrid.pdf,ltxutil.pdf,ltxutil.dvi}
	rm -fv "${ED}/usr/share/doc/${P}/"{textcase.dvi,revtex4.dvi,ltxgrid.dvi,ltxdocext.dvi}
}
