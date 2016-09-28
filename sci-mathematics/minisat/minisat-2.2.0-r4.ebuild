# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
SRC_URI="http://minisat.se/downloads/${P}.tar.gz
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="debug doc extended-solver"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

DOCS=( README doc/ReleaseNotes-2.2.0.txt )
PATCHES=( "${FILESDIR}"/${P}-header_fix.patch )

S=${WORKDIR}/${PN}

src_prepare() {
	default
	# Remove makefile silencing
	sed -i -e 's:@\(\$\|ln\|rm\|for\):\1:g'	mtl/template.mk || die
}

src_configure() {
	myconf=$(usex debug d r)
	myext=$(usex debug debug release)
	mydir=$(usex extended-solver simp core)

	tc-export CXX
}

src_compile() {
	export MROOT="$S"
	emake -C $mydir $myconf
	LIB="${PN}" emake -C $mydir lib$myconf
}

src_install() {
	insinto /usr/include/${PN}2/mtl
	doins mtl/*.h

	insinto /usr/include/${PN}2/core
	doins core/Solver*.h

	insinto /usr/include/${PN}2/simp
	doins simp/Simp*.h

	insinto /usr/include/${PN}2/utils
	doins utils/*.h

	newbin ${mydir}/${PN}_${myext} ${PN}
	newlib.a ${mydir}/lib${PN}_${myext}.a lib${PN}.a

	use doc && DOCS+=( "${DISTDIR}"/MiniSat.pdf )
	einstalldocs
}
