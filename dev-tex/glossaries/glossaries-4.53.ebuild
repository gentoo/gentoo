# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="Create glossaries and lists of acronyms"
HOMEPAGE="https://www.ctan.org/pkg/glossaries/"
# The real origin of this is
# https://mirrors.ctan.org/macros/latex/contrib/glossaries.zip, which
# is, unfortunately, unversioned.
SRC_URI="https://dev.gentoo.org/~flow/distfiles/glossaries/${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc examples"

RDEPEND="
	dev-lang/perl
	dev-texlive/texlive-latexrecommended
	>=dev-texlive/texlive-latexextra-2012
	dev-texlive/texlive-plaingeneric
"
BDEPEND="
	${RDEPEND}
	app-arch/unzip
"

TEXMF="/usr/share/texmf-dist"
S=${WORKDIR}/${PN}

src_install() {
	latex-package_src_doinstall styles

	dobin makeglossaries

	dodoc CHANGES
	if use doc ; then
		latex-package_src_doinstall pdf
	fi
	if use examples ; then
		docinto examples
		dodoc samples/*.tex
	fi
}
