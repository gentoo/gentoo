# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/lgrind/lgrind-3.67-r3.ebuild,v 1.6 2014/08/10 21:27:03 slyfox Exp $

inherit latex-package toolchain-funcs eutils

DESCRIPTION="A source pretty printer for LaTeX - styles to stylise your source and code examples"
SRC_URI="mirror://gentoo/${PN}.tar.gz"

LICENSE="BSD LGrind-Jacobson"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="examples"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo 'CFLAGS+=-DDEFSFILE=\"$(DEFSFILE)\" -DVERSION=\"$(VERSION)\"' > source/Makefile
	echo 'lgrind: lgrind.o lgrindef.o regexp.o' >>	source/Makefile
	epatch "${FILESDIR}/${P}-fgets.patch"
}

src_compile() {
	tc-export CC

	latex-package_src_compile
	cd "${S}"/source
	emake DEFSFILE="/usr/share/texmf/tex/latex/${PN}/lgrindef" VERSION="${PV}" || die
}

src_install() {
	# binary first
	dobin source/lgrind

	# then the texmf stuff
	latex-package_src_install
	insinto /usr/share/texmf/tex/latex/${PN}
	doins lgrindef

	# and finally, the documentation
	dodoc FAQ README
	if use examples ; then
		docinto examples
		dodoc example/*
	fi
	cd "${S}"/source
	doman lgrind.1 lgrindef.5
}
