# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs eutils multilib flag-o-matic

DESCRIPTION="High-performance and portable Number Theory C++ library"
HOMEPAGE="http://shoup.net/ntl/"
SRC_URI="http://www.shoup.net/ntl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc static-libs test"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/gf2x:0="
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${P}/src"

src_prepare() {
	# fix parallel make
	sed -i -e "s/make/make ${MAKEOPTS}/g" WizardAux || die
	cd ..
	# enable compatibility with singular
	# implement a call back framework (submitted upstream)
	# sanitize the makefile and allow the building of shared library
	epatch \
		"${FILESDIR}"/${PN}-6.0.0-singular.patch \
		"${FILESDIR}"/${PN}-6.0.0-sage-tools.patch \
		"${FILESDIR}"/${PN}-5.5.2-shared.patch
	replace-flags -O[3-9] -O2
}

src_configure() {
	perl DoConfig \
		PREFIX="${EPREFIX}"/usr \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		NTL_STD_CXX=on NTL_GMP_LIP=on NTL_GF2X_LIB=on \
		|| die "DoConfig failed"
}

src_compile() {
	# split the targets to allow parallel make to run properly
	emake setup1 setup2
	emake setup3
	sh Wizard on || die "Tuning wizard failed"
	if use static-libs || use test; then
		emake ntl.a
	fi
	local trg=so
	[[ ${CHOST} == *-darwin* ]] && trg=dylib
	emake shared${trg}
}

src_install() {
	dolib.so lib*$(get_libname)
	use static-libs && newlib.a ntl.a libntl.a

	cd ..
	insinto /usr/include
	doins -r include/NTL

	dodoc README
	if use doc ; then
		dodoc doc/*.txt
		dohtml doc/*
	fi
}
