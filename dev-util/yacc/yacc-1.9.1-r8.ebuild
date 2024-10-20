# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Yacc: Yet Another Compiler-Compiler"
HOMEPAGE="http://dinosaur.compilertools.net/#yacc"
SRC_URI="
	ftp://metalab.unc.edu/pub/Linux/devel/compiler-tools/${P}.tar.Z
	https://dev.gentoo.org/~arthurzam/distfiles/dev-util/${PN}/${P}-modern-C.patch.xz
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	# mkstemp patch from byacc ebuild.
	"${FILESDIR}/${P}-mkstemp.patch"

	# The following patch fixes yacc to run correctly on ia64 (and
	# other 64-bit arches). See bug 46233.
	"${FILESDIR}/${P}-ia64.patch"

	# Avoid stack access error. See bug 232005.
	"${FILESDIR}/${P}-CVE-2008-3196.patch"

	# fixes for modern C compiler, bug #730802
	"${WORKDIR}/${P}-modern-C.patch"
)

src_prepare() {
	default

	# Use our CFLAGS and LDFLAGS.
	sed -i -e 's: -O : $(CFLAGS) $(LDFLAGS) :' Makefile || die 'sed failed'
}

src_compile() {
	emake clean
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	newbin yacc yacc-reference
	newman yacc.1 yacc-reference.1
	dodoc 00README* ACKNOWLEDGEMENTS NEW_FEATURES NO_WARRANTY NOTES README*
}
