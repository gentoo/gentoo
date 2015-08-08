# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit latex-package

DESCRIPTION="LaTeX class for creating presentations using a video projector"
HOMEPAGE="http://bitbucket.org/rivanvx/beamer/wiki/Home"
SRC_URI="http://dev.gentoo.org/~radhermit/dist/${P}.zip"

LICENSE="GPL-2 FDL-1.2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples"

DEPEND="app-arch/unzip
	dev-texlive/texlive-latex"
RDEPEND=">=dev-tex/pgf-1.10
	dev-tex/xcolor
	!dev-tex/translator"

S=${WORKDIR}/beamer

src_install() {
	insinto /usr/share/texmf-site/tex/latex/beamer
	doins -r base

	dodoc AUTHORS ChangeLog README TODO doc/licenses/LICENSE

	if use doc ; then
		docinto doc
		dodoc -r doc/*
	fi

	use examples && dodoc -r examples solutions
}
