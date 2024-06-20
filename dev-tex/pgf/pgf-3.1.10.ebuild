# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="The TeX Portable Graphic Format"
HOMEPAGE="https://github.com/pgf-tikz/pgf"
SRC_URI="
	https://github.com/pgf-tikz/pgf/archive/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://github.com/pgf-tikz/pgf/releases/download/${PV}/pgfmanual-${PV}.pdf -> ${P}-pgfmanual.pdf )
"

LICENSE="GPL-2 LPPL-1.3c FDL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc source"

RDEPEND="dev-texlive/texlive-latexrecommended"

src_install() {
	einstalldocs

	insinto "${TEXMF}"
	doins -r tex
	insinto "${TEXMF}"/tex/generic/${PN}
	# Here is one of the rare examples where you want to quote the label
	# of the heredoc to prevent the backticks from being evaluated.
	newins - pgf.revision.tex <<"EOF"
\begingroup
\catcode`\-=12
\catcode`\/=12
\catcode`\.=12
\catcode`\:=12
\catcode`\+=12
\catcode`\-=12
\gdef\pgfrevision{@PVR@}
\gdef\pgfversion{@PVR@}
\gdef\pgfversiondatetime{2024-02-09 00:00:00 +0000}
\gdef\pgfrevisiondatetime{2024-02-09 00:00:00 +0000}
\gdef\pgf@glob@TMPa#1-#2-#3 #4\relax{#1/#2/#3}
\xdef\pgfversiondate{\expandafter\pgf@glob@TMPa\pgfversiondatetime\relax}
\xdef\pgfrevisiondate{\expandafter\pgf@glob@TMPa\pgfrevisiondatetime\relax}
\endgroup
EOF
	sed -i s/@PVR@/${PVR}/ "${ED}/${TEXMF}"/tex/generic/${PN}/pgf.revision.tex || die

	if use source ; then
		doins -r source
	fi

	if use doc; then
		cd "${S}/doc/generic/pgf" || die
		docinto texdoc
		# pgfmanual is now split from the main tar archive
		newdoc "${DISTDIR}/${P}-pgfmanual.pdf" pgfmanual.pdf
		doins -r images

		dosym "../../../doc/${PF}/texdoc" "${TEXMF}/doc/latex/${PN}"
		docompress -x "/usr/share/doc/${P}/texdoc/"
	fi
}
