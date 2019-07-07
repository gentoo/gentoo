# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="The TeX Portable Graphic Format"
HOMEPAGE="https://sourceforge.net/projects/pgf"
SRC_URI="mirror://sourceforge/pgf/${PN}_${PV}.tds.zip"

LICENSE="GPL-2 LPPL-1.3c FDL-1.2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source"

RDEPEND="dev-texlive/texlive-latexrecommended
	>=dev-tex/xcolor-2.11"
BDEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	# Bug #607642
	cp "${FILESDIR}/pgfsys-luatex.def" "${WORKDIR}/tex/generic/pgf/systemlayer/" || die

	insinto ${TEXMF}
	doins -r tex

	if use source ; then
		doins -r source
	fi

	cd "${S}/doc/generic/pgf" || die
	dodoc AUTHORS ChangeLog README
	if use doc ; then
		insinto /usr/share/doc/${PF}/texdoc
		doins pgfmanual.pdf
		doins -r images macros text-en version-*
		dosym /usr/share/doc/${PF}/texdoc ${TEXMF}/doc/latex/${PN}
		docompress -x /usr/share/doc/${PF}/texdoc/
	fi
}
