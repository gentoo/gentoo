# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake fortran-2

DESCRIPTION="A package for unstructured serial graph partitioning"
HOMEPAGE="https://www-users.cs.umn.edu/~karypis/metis/metis/"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp"

RDEPEND="!sci-libs/parmetis"

PATCHES=(
	"${FILESDIR}"/${P}-datatype.patch
	"${FILESDIR}"/${P}-shared-GKlib.patch
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-remove-GKlib-O3.patch
)

src_configure() {
	local mycmakeargs=(
		-DGKLIB_PATH="${S}"/GKlib
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

	cat >> "${T}"/metis.pc <<- EOF || die
		prefix=${EPREFIX}/usr
		exec_prefix=\${prefix}
		libdir=\${exec_prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: METIS
		Description: Software for partioning unstructured graphes and meshes
		Version: ${PV}
		Cflags: -I\${includedir}/metis
		Libs: -L\${libdir} -lmetis
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/metis.pc
}
