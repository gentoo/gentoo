# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

YYYY=${PV:0:4}
MMDD=${PV:4:4}
MYPV=${YYYY}${MMDD}

DESCRIPTION="Library for algorithms for models in fundamental astronomy"
HOMEPAGE=" http://www.iausofa.org/current_C.html"
SRC_URI="http://www.iausofa.org/${YYYY}_${MMDD}_C/${PN}-${MYPV}.tar.gz"
S="${WORKDIR}/sofa/${MYPV}/c/src"

LICENSE="SOFA"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default
	sed -e "s:/lib:/$(get_libdir):" -i makefile || die
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" install
	cd ..
	dodoc 00READ.ME
	use doc && dodoc doc/*.lis doc/*.pdf
}
