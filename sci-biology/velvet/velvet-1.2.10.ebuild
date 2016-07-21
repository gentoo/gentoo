# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

MY_P=${PN}_${PV}

DESCRIPTION="A sequence assembler for very short reads"
HOMEPAGE="http://www.ebi.ac.uk/~zerbino/velvet/"
SRC_URI="http://www.ebi.ac.uk/~zerbino/velvet/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc openmp"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	if ! use doc; then
		sed -i -e '/default :/ s/doc//' "${S}"/Makefile || die
	fi
	elog "Upstream recommendes using -O3 in CFLAGS"
	echo
	elog "To adjust the MAXKMERLENGTH or CATEGORIES parameters as described in the manual,"
	elog "please set the variables VELVET_MAXKMERLENGTH or VELVET_CATEGORIES in your"
	elog "environment or /etc/make.conf, then re-emerge the package. For example:"
	elog "  VELVET_MAXKMERLENGTH=NN emerge [options] velvet"
	MAKEOPTS+=" -j1"

	if [[ $(tc-getCC) =~ gcc ]]; then
		local eopenmp=-fopenmp
	elif [[ $(tc-getCC) =~ icc ]]; then
		local eopenmp=-openmp
	else
		elog "Cannot detect compiler type so not setting openmp support"
	fi
	append-flags -fPIC ${eopenmp}
	append-ldflags ${eopenmp}

	tc-export CC

	MAKE_XOPTS=(
		CC=$(tc-getCC)
		CFLAGS="${CFLAGS}"
		OPT="${CFLAGS}"
	)
	if [[ ${VELVET_MAXKMERLENGTH} != "" ]]; then MAKE_XOPTS+=( MAXKMERLENGTH=${VELVET_MAXKMERLENGTH} ); fi
	if [[ ${VELVET_CATEGORIES} != "" ]]; then MAKE_XOPTS+=( CATEGORIES=${VELVET_CATEGORIES} ); fi
}

src_compile() {
	emake "${MAKE_XOPTS[@]}"
	emake "${MAKE_XOPTS[@]}" color
}

src_test() {
	emake "${MAKE_XOPTS[@]}" test
}

src_install() {
	dobin velvet{g,h,g_de,h_de}
	insinto /usr/share/${PN}
	doins -r contrib
	dodoc Manual.pdf CREDITS.txt ChangeLog
}
