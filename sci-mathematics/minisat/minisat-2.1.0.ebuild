# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/minisat/minisat-2.1.0.ebuild,v 1.2 2014/08/10 20:23:37 slyfox Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_P="${PN}2-070721"

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
SRC_URI="http://minisat.se/downloads/${MY_P}.zip
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="debug doc extended-solver"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	if use debug; then
		myconf="d"
		myext="debug"
	else
		myconf="r"
		myext="release"
	fi

	if use extended-solver; then
		mydir="simp"
	else
		mydir="core"
	fi

	tc-export CXX

	if has_version ">=sci-mathematics/minisat-2.2.0" ; then
		elog ""
		elog "The minisat2 2.1 and 2.2 ABIs are not compatible and there"
		elog "is currently no slotting.  Please mask it yourself (eg, in"
		elog "packages.mask) if you need to use the 2.1x version."
		elog ""
		epause 5
	fi
}

src_prepare() {
	sed -i \
		-e "s|-O3|${CFLAGS} ${LDFLAGS}|" \
		-e "s|@\$(CXX)|\$(CXX)|" \
		mtl/template.mk || die
}

src_compile() {
	export MROOT="${S}"
	emake -C ${mydir} "$myconf" || die

	if ! use debug; then
		LIB="${PN}" emake -C ${mydir} lib || die
	else
		LIB="${PN}" emake -C ${mydir} libd || die
	fi
}

src_install() {
	# somewhat brute-force, but so is the build setup...

	insinto /usr/include/${PN}2/mtl
	doins mtl/*.h || die

	insinto /usr/include/${PN}2/core
	doins core/Solver*.h || die

	insinto /usr/include/${PN}2/simp
	doins simp/Simp*.h || die

	if ! use debug; then
		newbin ${mydir}/${PN}_${myext} ${PN} || die
		dolib.a ${mydir}/lib${PN}.a || die
	else
		newbin ${mydir}/${PN}_${myext} ${PN} || die
		newlib.a ${mydir}/lib${PN}_${myext}.a lib${PN}.a || die
	fi

	dodoc README || die
	if use doc; then
		dodoc "${DISTDIR}"/MiniSat.pdf || die
	fi
}
