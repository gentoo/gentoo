# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

YYYY=${PV:0:4}
MMDD=${PV:4:4}
#PP=${PV:8:1}
MYPV=${YYYY}${MMDD}

DESCRIPTION="Library for algorithms for models in fundamental astronomy"
HOMEPAGE=" http://www.iausofa.org/current_C.html"
SRC_URI="http://www.iausofa.org/${YYYY}_${MMDD}_C/${PN}-${MYPV}.tar.gz"

LICENSE="SOFA"
SLOT=0
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=""
DEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )

S="${WORKDIR}/sofa/${MYPV}/c/src"

src_prepare() {
	default
	sed -i -e "s:/lib:/$(get_libdir):" makefile || die
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" install
	cd ..
	dodoc 00READ.ME
	use doc && dodoc doc/*.lis doc/*.pdf
}
