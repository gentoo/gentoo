# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package toolchain-funcs

DESCRIPTION="A pretty printer for various programming languages with tex output"
SRC_URI="
	https://dev.gentoo.org/~dilfridge/distfiles/${P}.tgz
	https://salsa.debian.org/debian/lgrind/-/raw/dbf049621a61720c8350c37659cf6537ac3893a9/debian/patches/texlive-2022.patch
		-> lgrind-3.67-texlive-2022.patch
	https://salsa.debian.org/debian/lgrind/-/raw/dbf049621a61720c8350c37659cf6537ac3893a9/debian/patches/texlive-2020.patch
		-> lgrind-3.67-fix-begin-document.patch
"
S="${WORKDIR}/${PN}"

LICENSE="BSD LGrind-Jacobson"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

IUSE="examples"

# Depend on latexextra for hypdoc.sty, see https://bugs.gentoo.org/928305
DEPEND="dev-texlive/texlive-latexextra"

PATCHES=(
	"${FILESDIR}"/${PN}-3.67-fgets.patch
	"${FILESDIR}"/${PN}-3.67-fix-return-with-no-value.patch
	"${DISTDIR}"/${PN}-3.67-texlive-2022.patch
	"${DISTDIR}"/${PN}-3.67-fix-begin-document.patch
)

src_prepare() {
	echo 'CFLAGS+=-DDEFSFILE=\"$(DEFSFILE)\" -DVERSION=\"$(VERSION)\"' > source/Makefile || die "Fixing Makefile failed"
	echo 'lgrind: lgrind.o lgrindef.o regexp.o' >>	source/Makefile || die "Fixing Makefile failed"
	default
}

src_compile() {
	tc-export CC

	latex-package_src_compile
	emake -C source DEFSFILE="/usr/share/texmf/tex/latex/${PN}/lgrindef" VERSION="${PV}"
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

	cd source || die
	doman lgrind.1 lgrindef.5
}
