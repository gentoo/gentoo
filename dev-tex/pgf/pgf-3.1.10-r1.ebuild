# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="doc source"

RDEPEND="dev-texlive/texlive-latexrecommended"

# ADJUST ON BUMPS: The date of the according release tag. See also
# upstream's build.lua
PGF_VERSION_DATE="2023-01-15"

src_install() {
	einstalldocs

	insinto "${TEXMF}"
	doins -r tex
	insinto "${TEXMF}"/tex/generic/${PN}
	newins - pgf.revision.tex <<EOF
\\def\\pgfrevision{${PV}}
\\def\\pgfversion{${PV}}
\\def\\pgfrevisiondate{${PGF_VERSION_DATE}}
\\def\\pgfversiondate{${PGF_VERSION_DATE}}
EOF

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
