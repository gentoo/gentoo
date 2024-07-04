# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Scalable Algorithms for Parallel Adaptive Mesh Refinement on Forests of Octrees"
HOMEPAGE="http://www.p4est.org/"

LIBSC_VERSION="${PV}"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cburstedde/${PN}.git"
	EGIT_BRANCH="develop"
	SRC_URI=""
else
	SRC_URI="https://github.com/cburstedde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

# TODO petsc
IUSE="debug doc examples mpi openmp threads +vtk-binary"

RDEPEND="
	~sci-libs/libsc-${LIBSC_VERSION}[mpi=,openmp=,threads=]
	sys-apps/util-linux
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi[romio] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fix_build_system.patch
	"${FILESDIR}"/${P}-set_version.patch
	"${FILESDIR}"/${P}-fix_cmake_path.patch
	"${FILESDIR}"/${P}-use_external_sc.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# avoid using debug codepaths that are manually enabled with the
	# RelWithDebInfo build type
	local CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DP4EST_ENABLE_MPI="$(usex mpi)"
		-Dlibrary_reldir="$(get_libdir)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	mkdir -p "${ED}"/usr/share/doc/${PF}
	mv "${ED}"/usr/share/docs/P4EST/* "${ED}"/usr/share/doc/${PF}/ || die "mv failed"
	rm -r "${ED}"/usr/share/docs || die "rm failed"
}
