# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Parallel (MPI) unstructured graph partitioning library"
HOMEPAGE="http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
SRC_URI="http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples openmp pcre"
RESTRICT="mirror bindist"

DEPEND=">=sci-libs/metis-5.1.0-r5
	virtual/mpi[fortran]
	pcre? ( dev-libs/libpcre:= )"
RDEPEND="${DEPEND}
	!<sci-libs/metis-5.1.0-r5"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.3-01-cmake-paths.patch
	"${FILESDIR}"/${PN}-4.0.3-02-unbundle-metis.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	export CC=mpicc CXX=mpicxx
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGKLIB_PATH="${S}/metis/GKlib"
		-DGKRAND=ON
		-DMETIS_PATH="${EPREFIX}/usr"
		-DOPENMP=$(usex openmp)
		-DPCRE=$(usex pcre)
		-DSHARED=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc Changelog
	use doc && dodoc manual/manual.pdf
	if use examples; then
		docinto examples
		dodoc -r Graphs programs
	fi

	cat > ${PN}.pc <<-EOF
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${PN}
		Cflags: -I\${includedir}/${PN}
		Requires: metis
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
