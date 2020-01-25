# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="The TeX Portable Graphic Format"
HOMEPAGE="https://github.com/pgf-tikz/pgf"
SRC_URI=" https://github.com/pgf-tikz/pgf/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zlogene/distfiles/${CATEGORY}/${PN}/${P}-revisioned.xz
	doc? ( https://github.com/pgf-tikz/pgf/releases/download/${PV}/pgfmanual.pdf -> ${P}-pgfmanual.pdf )"

LICENSE="GPL-2 LPPL-1.3c FDL-1.2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source"

RDEPEND="dev-texlive/texlive-latexrecommended"

src_install() {
	insinto "${TEXMF}"
	doins -r tex
	insinto "${TEXMF}"/tex/generic/${PN}
	newins "${WORKDIR}"/${P}-revisioned pgf.revision.tex

	if use source ; then
		doins -r source
	fi

	cd "${S}/doc/generic/pgf" || die
	dodoc AUTHORS ChangeLog README
	if use doc; then
		docinto texdoc
		# pgfmanual is now split from the main tar archive
		newdoc "${DISTDIR}/${P}-pgfmanual.pdf" pgfmanual.pdf
		doins -r images macros text-en version-*
		rm version-for-dvisvgm/en/color.cfg || die # bug 700056

		dosym "../../../doc/${PF}/texdoc" "${TEXMF}/doc/latex/${PN}"
		docompress -x "/usr/share/doc/${P}/texdoc/"
	fi
}
