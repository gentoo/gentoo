# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit latex-package

DESCRIPTION="Create glossaries and lists of acronyms"
HOMEPAGE="http://www.ctan.org/pkg/glossaries/"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.zip"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples"

RDEPEND="
	dev-lang/perl
	dev-texlive/texlive-latexrecommended
	>=dev-texlive/texlive-latexextra-2012
	|| ( dev-texlive/texlive-plaingeneric >=dev-texlive/texlive-genericextra-2014 )
	"
DEPEND="
	${RDEPEND}
	app-arch/unzip
	"

TEXMF="/usr/share/texmf-site"

S="${WORKDIR}/source/latex/${PN}"

src_compile() {
	latex-package_src_compile
}

src_test() {
	latex minimalgls
	"${WORKDIR}"/scripts/${PN}/makeglossaries minimalgls
	for f in minimalgls.{acr,gls} ; do
		test -f $f || die "Failed to create file $f."
	done
}

src_install() {
	latex-package_src_doinstall styles

	dobin "${WORKDIR}"/scripts/${PN}/makeglossaries
	doman "${WORKDIR}"/doc/man/man1/makeglossaries.1

	cd "${WORKDIR}"/doc/latex/${PN}
	dodoc CHANGES README

	# could be compiled as well (see doc/latex/glossaries/INSTALL) - however copying is faster and less errorprone
	if use doc ; then
		latex-package_src_doinstall pdf
	fi

	if use examples ; then
		docinto examples
		dodoc samples/*.tex
	fi
}
