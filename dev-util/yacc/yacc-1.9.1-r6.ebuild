# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Yacc: Yet Another Compiler-Compiler"
HOMEPAGE="http://dinosaur.compilertools.net/#yacc"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/devel/compiler-tools/${P}.tar.Z"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"

PATCHES=(
	# mkstemp patch from byacc ebuild.
	"${FILESDIR}/${P}-mkstemp.patch"

	# The following patch fixes yacc to run correctly on ia64 (and
	# other 64-bit arches). See bug 46233.
	"${FILESDIR}/${P}-ia64.patch"

	# Avoid stack access error. See bug 232005.
	"${FILESDIR}/${P}-CVE-2008-3196.patch"
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
	dobin "${PN}"
	doman "${PN}.1"
	dodoc 00README* ACKNOWLEDGEMENTS NEW_FEATURES NO_WARRANTY NOTES README*
}

pkg_preinst() {
	# bison installs a /usr/bin/yacc symlink ...
	# we need to remove it to avoid triggering
	# collision-protect errors. See bug 90089.
	if [[ -L "${ROOT}/usr/bin/${PN}" ]]; then
		rm -v "${ROOT}/usr/bin/${PN}" || die
	fi
}

pkg_postrm() {
	# and if we uninstall yacc but keep bison,
	# let's restore the /usr/bin/yacc symlink.
	if [[ ! -e "${ROOT}/usr/bin/${PN}" ]] && [[ -e "${ROOT}/usr/bin/${PN}.bison" ]]; then
		ln -s yacc.bison "${ROOT}/usr/bin/${PN}" || die
	fi
}
