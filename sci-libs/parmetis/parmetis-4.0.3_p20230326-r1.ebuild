# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

COMMIT="8ee6a372ca703836f593e3c450ca903f04be14df"

DESCRIPTION="Parallel (MPI) unstructured graph partitioning library"
HOMEPAGE="https://github.com/KarypisLab/ParMETIS"
SRC_URI="https://github.com/KarypisLab/ParMETIS/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ParMETIS-${COMMIT}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~riscv ~x86"
IUSE="examples openmp pcre"
RESTRICT="mirror bindist"

DEPEND="
	sci-libs/gklib
	>=sci-libs/metis-5.2.1-r2
	virtual/mpi[fortran]
	pcre? ( dev-libs/libpcre:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-respect-user-flags.patch
	"${FILESDIR}"/${P}-multilib.patch
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
	dodoc manual/manual.pdf
	if use examples; then
		docinto examples
		dodoc -r graphs programs
	fi

	cat > ${PN}.pc <<-EOF
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lparmetis -lGKlib
		Cflags: -I\${includedir}
		Requires: metis
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
