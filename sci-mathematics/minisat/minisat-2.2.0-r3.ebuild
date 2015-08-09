# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

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

	if has_version "=sci-mathematics/minisat-2.1*" ; then
		elog ""
		elog "The minisat2 2.1 and 2.2 ABIs are not compatible and there"
		elog "is currently no slotting.  Please mask it yourself (eg, in"
		elog "packages.mask) if you still need the older version."
		elog ""
		epause 5
	fi
}

src_prepare() {
	sed -e "s/\$(CXX) \$^/\$(CXX) \$(LDFLAGS) \$^/" \
		-i -e "s|-O3|${CFLAGS}|" mtl/template.mk || die
}

src_compile() {
	export MROOT="${S}"
	emake -C ${mydir} "$myconf" || die
	LIB="${PN}" emake -C ${mydir} lib"$myconf" || die
}

src_install() {
	# somewhat brute-force, but so is the build setup...
	fix_headers

	insinto /usr/include/${PN}2/mtl
	doins mtl/*.h || die

	insinto /usr/include/${PN}2/core
	doins core/Solver*.h || die

	insinto /usr/include/${PN}2/simp
	doins simp/Simp*.h || die

	insinto /usr/include/${PN}2/utils
	doins utils/*.h || die

	newbin ${mydir}/${PN}_${myext} ${PN} || die
	newlib.a ${mydir}/lib${PN}_${myext}.a lib${PN}.a || die

	dodoc README doc/ReleaseNotes-2.2.0.txt || die
	if use doc; then
		dodoc "${DISTDIR}"/MiniSat.pdf || die
	fi
}

fix_headers() {
	# need to fix the circular internal includes a bit for standard usage
	elog "Fixing header files..."

	patch -p0 < "${FILESDIR}"/${P}-header_fix.patch \
		|| die "header patch failed..."
}
