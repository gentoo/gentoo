# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils fortran-2

DESCRIPTION="A package for unstructured serial graph partitioning"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/metis/"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
LICENSE="Apache-2.0"
IUSE="doc openmp static-libs"

DEPEND=""
RDEPEND="${DEPEND}
	!sci-libs/parmetis"

DOCS=( manual/manual.pdf )

PATCHES=(
	"${FILESDIR}"/${P}-datatype.patch
	"${FILESDIR}"/${P}-shared-GKlib.patch
	"${FILESDIR}"/${P}-multilib.patch
)

src_prepare() {
	sed \
		-e 's:-O3::g' \
		-i GKlib/GKlibSystem.cmake || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGKLIB_PATH="${S}"/GKlib
		-DSHARED="$(usex static-libs no yes)"
		-DOPENMP="$(usex openmp)"
	)
	cmake-utils_src_configure
}

src_test() {
	cd graphs || die
	PATH="${BUILD_DIR}"/programs/:${PATH} LD_LIBRARY_PATH="${BUILD_DIR}"/lib ndmetis mdual.graph || die
	PATH="${BUILD_DIR}"/programs/:${PATH} LD_LIBRARY_PATH="${BUILD_DIR}"/lib mpmetis metis.mesh 2 || die
	PATH="${BUILD_DIR}"/programs/:${PATH} LD_LIBRARY_PATH="${BUILD_DIR}"/lib gpmetis test.mgraph 4 || die
	PATH="${BUILD_DIR}"/programs/:${PATH} LD_LIBRARY_PATH="${BUILD_DIR}"/lib gpmetis copter2.graph 4 || die
	PATH="${BUILD_DIR}"/programs/:${PATH} LD_LIBRARY_PATH="${BUILD_DIR}"/lib graphchk 4elt.graph || die
}

src_install() {
	cat >> "${T}"/metis.pc <<- EOF
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
	cmake-utils_src_install
}
