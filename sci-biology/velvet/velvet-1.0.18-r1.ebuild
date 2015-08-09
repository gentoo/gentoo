# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs flag-o-matic

MY_P=${PN}_${PV}

DESCRIPTION="A sequence assembler for very short reads"
HOMEPAGE="http://www.ebi.ac.uk/~zerbino/velvet/"
SRC_URI="http://www.ebi.ac.uk/~zerbino/velvet/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE="-doc"
KEYWORDS="amd64 x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	# necessary?
	# append-flags -O3 # as recommended by upstream
	epatch "${FILESDIR}"/${P}-gentoo-r1.diff
	use doc || sed -i -e '/default :/ s/doc//' "${S}"/Makefile || die
}

src_compile() {
	tc-export CC
	MAKE_XOPTS=""
	if [[ $VELVET_MAXKMERLENGTH != "" ]]; then MAKE_XOPTS="$MAKE_XOPTS MAXKMERLENGTH=$VELVET_MAXKMERLENGTH"; fi
	if [[ $VELVET_CATEGORIES != "" ]]; then MAKE_XOPTS="$MAKE_XOPTS CATEGORIES=$VELVET_CATEGORIES"; fi
	emake -j1 $MAKE_XOPTS || die
	emake -j1 $MAKE_XOPTS color || die
}

src_install() {
	dobin velvet{g,h,g_de,h_de} || die
	insinto /usr/share/${PN}
	doins -r contrib || die
	dodoc Manual.pdf CREDITS.txt ChangeLog || die
}

pkg_postinst() {
	elog "To adjust the MAXKMERLENGTH or CATEGORIES parameters as described in the manual,"
	elog "please set the variables VELVET_MAXKMERLENGTH or VELVET_CATEGORIES in your"
	elog "environment or /etc/make.conf, then re-emerge the package. For example:"
	elog "	VELVET_MAXKMERLENGTH=NN emerge [options] velvet"
}
