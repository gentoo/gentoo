# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

DESCRIPTION="Unicode support for LaTeX"
HOMEPAGE="http://www.unruh.de/DniQ/latex/unicode/"
# Taken from
#SRC_URI="http://www.unruh.de/DniQ/latex/unicode/unicode.tgz"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://www.unicode.org/Public/UNIDATA/UnicodeData.txt"

LICENSE="LPPL-1.2"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="cjk"

DEPEND="!dev-texlive/texlive-latexrecommended
	cjk? ( dev-tex/cjk-latex )"

S=${WORKDIR}/ucs

src_unpack() {
	unpack ${P}.tar.gz
	cp "${DISTDIR}"/UnicodeData.txt "${S}"
}

src_compile() {

	latex-package_src_compile

	if ! use cjk ; then
		rm -rf data/*
		perl makeunidef.pl -t data -v --nocomments --exclude cjkbg5,cjkgb,cjkjis,cjkhangul config/* || die "makeunidef.pl failed"
	fi
}

src_install() {

	latex-package_src_doinstall
	pushd contrib
	latex-package_src_doinstall styles || die
	popd
	pushd data
	latex-package_src_doinstall styles || die
	popd

	insinto /usr/share/texmf/tex/latex/latex-unicode
	doins data/uninames.dat
	doins config/* contrib/cenccmn.tex

	dodoc FAQ README VERSION languages.ps.gz ltxmacrs.txt
}

pkg_postinst() {

	latex-package_pkg_postinst
	elog
	elog "Please refer to the README file in /usr/share/doc/${PF}"
	elog "and languages.ps in that directory for language-specific examples."
	elog
}
