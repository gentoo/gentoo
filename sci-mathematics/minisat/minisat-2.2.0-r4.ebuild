# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Small yet efficient SAT solver with reference paper"
HOMEPAGE="http://minisat.se/Main.html"
SRC_URI="http://minisat.se/downloads/${P}.tar.gz
	doc? ( http://minisat.se/downloads/MiniSat.pdf )"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="MIT"

IUSE="debug doc +extended-solver"

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
	tc-export CXX AR

	if has_version "=sci-mathematics/minisat-2.1*" ; then
		ewarn ""
		ewarn "The minisat2 2.1 and 2.2 ABIs are not compatible and there"
		ewarn "is currently no slotting.  Please mask it yourself (eg, in"
		ewarn "package.mask) if you still need the older version."
		ewarn ""
	fi
}

src_prepare() {
	sed -i -e "s/\$(CXX) \$^/\$(CXX) \$(LDFLAGS) \$^/" \
		-e "s|-O3|${CFLAGS}|" \
		mtl/template.mk || die
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
	# Doh! Main.o causes symbol conflicts in clients using libminisat.a
	elog "Fixing static library..."
	${AR} -dv ${mydir}/lib${PN}_${myext}.a Main.o${myconf}
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
