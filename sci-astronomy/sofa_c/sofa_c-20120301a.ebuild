# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/sofa_c/sofa_c-20120301a.ebuild,v 1.2 2013/07/16 22:46:43 bicatali Exp $

EAPI=5

inherit eutils flag-o-matic multilib

YYYY=${PV:0:4}
MMDD=${PV:4:4}
MYPV=${YYYY}${MMDD}_${PV:8:1}

DESCRIPTION="Library for algorithms for models in fundamental astronomy"
HOMEPAGE=" http://www.iausofa.org/current_C.html"
SRC_URI="http://www.iausofa.org/${YYYY}_${MMDD}_C/${PN}-${MYPV}.tar.gz"

LICENSE="SOFA"
SLOT=0
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=""
DEPEND=""

S="${WORKDIR}/sofa/${MYPV}/c/src"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-makefile.patch
	sed -i -e "s:/lib:/$(get_libdir):" makefile || die
	replace-flags -O? -O1
}

src_install() {
	emake DESTDIR="${ED}" -j1 install
	cd ..
	dodoc 00READ.ME
	use doc && dodoc doc/*.lis doc/*.pdf
}
