# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="High-performance and portable Number Theory C++ library"
HOMEPAGE="http://shoup.net/ntl/"
SRC_URI="http://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs test"

RDEPEND="dev-libs/gmp:0=
	>=dev-libs/gf2x-0.9"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}/src"
PATCHES=(
	"${FILESDIR}/${P}-sanitize-makefile.patch"
	"${FILESDIR}/${PN}-9.2.0-singular.patch"
)

src_prepare() {
	# fix parallel make
	sed -i -e "s/make/make ${MAKEOPTS}/g" WizardAux || die
	cd .. || die
	default

	replace-flags -O[3-9] -O2
}

src_configure() {
	perl DoConfig \
		PREFIX="${EPREFIX}"/usr \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		NTL_GMP_LIP=on NTL_GF2X_LIB=on NTL_LEGACY_SP_MULMOD=on \
		|| die "DoConfig failed"
}

src_compile() {
	# split the targets to allow parallel make to run properly
	emake setup1 setup2
	emake setup3
	sh Wizard on || die "Tuning wizard failed"
	if use static-libs; then
		emake ntl.a
	fi
	local trg=so
	[[ ${CHOST} == *-darwin* ]] && trg=dylib
	emake shared${trg}
}

src_install() {
	if use static-libs; then
		newlib.a ntl.a libntl.a
	fi
	dolib.so lib*$(get_libname)

	cd .. || die
	insinto /usr/include
	doins -r include/NTL

	dodoc README
	if use doc ; then
		dodoc doc/*.txt
		docinto html
		dodoc doc/*.html doc/*.gif
	fi
}

src_test(){
	# the current ebuild need static library to run tests
	emake ntl.a

	default
}
