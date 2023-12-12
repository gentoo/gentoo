# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A package for unstructured serial graph partitioning"
HOMEPAGE="https://github.com/KarypisLab/METIS"
SRC_URI="https://github.com/KarypisLab/METIS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/METIS-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~arm64-macos ~x64-macos"
IUSE="double-precision examples int64 openmp"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-respect-user-flags.patch
	# https://github.com/KarypisLab/METIS/pull/52 Bug 905822
	"${FILESDIR}"/${P}-add-gklib-as-required.patch
)

DEPEND="sci-libs/gklib"
RDEPEND="${DEPEND}"

src_prepare() {
	local idxwidth realwidth

	if use int64; then
		idxwidth="#define IDXTYPEWIDTH 64"
	else
		idxwidth="#define IDXTYPEWIDTH 32"
	fi

	if use double-precision; then
		realwidth="#define REALTYPEWIDTH 64"
	else
		realwidth="#define REALTYPEWIDTH 32"
	fi

	cmake_src_prepare

	# From Makefile
	mkdir -p build/xinclude || die
	echo ${idxwidth} > build/xinclude/metis.h || die
	echo ${realwidth} >> build/xinclude/metis.h || die
	cat include/metis.h >> build/xinclude/metis.h || die
	cp include/CMakeLists.txt build/xinclude || die
}

src_configure() {
	local mycmakeargs=(
		-DSHARED=yes
		-DOPENMP=$(usex openmp)
	)
	cmake_src_configure
}

src_test() {
	cd graphs || die
	local PATH="${BUILD_DIR}"/programs/:${PATH}

	ndmetis mdual.graph || die
	mpmetis metis.mesh 2 || die
	gpmetis test.mgraph 4 || die
	gpmetis copter2.graph 4 || die
	graphchk 4elt.graph || die
}

src_install() {
	cmake_src_install
	dodoc manual/manual.pdf
	if use examples; then
		docinto examples
		dodoc -r programs graphs
	fi

	cat >> "${T}"/metis.pc <<- EOF || die
		prefix=${EPREFIX}/usr
		exec_prefix=\${prefix}
		libdir=\${exec_prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: METIS
		Description: Software for partioning unstructured graphes and meshes
		Version: ${PV}
		Cflags: -I\${includedir}
		Libs: -L\${libdir} -lmetis -lGKlib
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/metis.pc
}
