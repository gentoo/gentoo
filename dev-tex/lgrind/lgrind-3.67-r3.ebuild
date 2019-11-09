# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package toolchain-funcs

DESCRIPTION="A pretty printer for various programming languages with tex output."
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tgz"

LICENSE="BSD LGrind-Jacobson"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="examples"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}/${P}-fgets.patch" )

src_prepare() {
	echo 'CFLAGS+=-DDEFSFILE=\"$(DEFSFILE)\" -DVERSION=\"$(VERSION)\"' > source/Makefile || die "Fixing Makefile failed"
	echo 'lgrind: lgrind.o lgrindef.o regexp.o' >>	source/Makefile || die "Fixing Makefile failed"
	default
}

src_compile() {
	tc-export CC

	latex-package_src_compile
	cd "${S}"/source
	emake DEFSFILE="/usr/share/texmf/tex/latex/${PN}/lgrindef" VERSION="${PV}"
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
