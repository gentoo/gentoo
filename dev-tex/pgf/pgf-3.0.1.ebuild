# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package

DESCRIPTION="pgf -- The TeX Portable Graphic Format"
HOMEPAGE="http://sourceforge.net/projects/pgf"
SRC_URI="mirror://sourceforge/pgf/${PN}_${PV}.tds.zip"

LICENSE="GPL-2 LPPL-1.3c FDL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source"

RDEPEND="dev-texlive/texlive-latexrecommended
	>=dev-tex/xcolor-2.11"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_install() {
	insinto ${TEXMF}
	doins -r tex || die

	if use source ; then
		doins -r source || die
	fi

	cd "${S}/doc/generic/pgf"
	dodoc AUTHORS ChangeLog README || die
	if use doc ; then
		insinto /usr/share/doc/${PF}/texdoc
		doins pgfmanual.pdf || die
		doins -r images macros text-en version-* || die
		dosym /usr/share/doc/${PF}/texdoc ${TEXMF}/doc/latex/${PN} || die
		docompress -x /usr/share/doc/${PF}/texdoc/
	fi
}
