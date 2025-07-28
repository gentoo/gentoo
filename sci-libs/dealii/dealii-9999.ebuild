# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# deal.II uses its own FindLAPACK.cmake file that calls into the system
# FindLAPACK.cmake module and does additional internal setup. Do not remove
# any of these modules:
CMAKE_REMOVE_MODULES_LIST=""

inherit cmake flag-o-matic

DESCRIPTION="Solving partial differential equations with the finite element method"
HOMEPAGE="https://www.dealii.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dealii/dealii.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz
		doc? (
			https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}-offline_documentation.tar.gz
			)"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="
	adolc arborx assimp arpack cgal cpu_flags_x86_avx cpu_flags_x86_avx512f
	cpu_flags_x86_sse2 +debug doc +examples ginkgo gmsh +gsl hdf5 int64
	+lapack metis mpi mumps muparser opencascade p4est petsc scalapack slepc
	+sparse sundials symengine trilinos vtk
"

# TODO: add slepc use flag once slepc is packaged for gentoo-science
REQUIRED_USE="
	arborx? ( trilinos )
	p4est? ( mpi )
	slepc? ( petsc )
	trilinos? ( mpi )"

RDEPEND="dev-libs/boost:=
	app-arch/bzip2
	sys-libs/zlib
	dev-cpp/magic_enum:=
	dev-cpp/taskflow:=
	arborx? ( sci-libs/arborx[mpi=] )
	adolc? ( sci-libs/adolc )
	arpack? ( sci-libs/arpack[mpi=] )
	assimp? ( media-libs/assimp:= )
	cgal? ( sci-mathematics/cgal )
	ginkgo? ( sci-libs/ginkgo )
	gmsh? ( sci-libs/gmsh )
	gsl? ( sci-libs/gsl:= )
	hdf5? ( sci-libs/hdf5:=[mpi=] )
	lapack? ( virtual/lapack )
	metis? (
		>=sci-libs/metis-5
		mpi? ( >=sci-libs/parmetis-4 )
	)
	mpi? ( virtual/mpi[cxx] )
	mumps? ( sci-libs/mumps[mpi] )
	muparser? ( dev-cpp/muParser )
	opencascade? ( sci-libs/opencascade:= )
	p4est? ( sci-libs/p4est[mpi] )
	petsc? ( sci-mathematics/petsc[mpi=,int64?] )
	scalapack? ( sci-libs/scalapack )
	slepc? ( sci-mathematics/slepc[mpi=] )
	sparse? ( sci-libs/umfpack )
	sundials? ( sci-libs/sundials:= )
	symengine? ( >=sci-libs/symengine-0.4:= )
	trilinos? ( sci-libs/trilinos )
	vtk? ( sci-libs/vtk )
	|| (
		dev-cpp/kokkos
		sci-libs/trilinos
	)
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] dev-lang/perl )"

PATCHES=(
)

src_configure() {
	# deal.II needs a custom build type:
	local CMAKE_BUILD_TYPE=$(usex debug DebugRelease Release)

	local mycmakeargs=(
		-DDEAL_II_PACKAGE_VERSION="${PV}"
		-DCMAKE_CXX_STANDARD="20"
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF
		-DDEAL_II_ALLOW_AUTODETECTION=OFF
		-DDEAL_II_ALLOW_BUNDLED=OFF
		-DDEAL_II_ALLOW_PLATFORM_INTROSPECTION=OFF
		-DDEAL_II_COMPILE_EXAMPLES=OFF
		-DDEAL_II_DOCHTML_RELDIR="share/doc/${PF}/html"
		-DDEAL_II_DOCREADME_RELDIR="share/doc/${PF}"
		-DDEAL_II_COMPILE_EXAMPLES=OFF
		-DDEAL_II_EXAMPLES_RELDIR="share/doc/${PF}/examples"
		-DDEAL_II_LIBRARY_RELDIR="$(get_libdir)"
		-DDEAL_II_SHARE_RELDIR="share/${PN}"
		-DDEAL_II_COMPONENT_DOCUMENTATION="$(usex doc)"
		-DDEAL_II_COMPONENT_EXAMPLES="$(usex examples)"
		-DDEAL_II_WITH_64BIT_INDICES="$(usex int64)"
		-DDEAL_II_WITH_ADOLC="$(usex adolc)"
		-DDEAL_II_WITH_ARBORX="$(usex arborx)"
		-DDEAL_II_WITH_ARPACK="$(usex arpack)"
		-DDEAL_II_WITH_ASSIMP="$(usex assimp)"
		-DDEAL_II_WITH_CGAL="$(usex cgal)"
		-DDEAL_II_WITH_COMPLEX_VALUES=ON
		-DDEAL_II_WITH_GINKGO="$(usex ginkgo)"
		-DDEAL_II_WITH_GMSH="$(usex gmsh)"
		-DDEAL_II_WITH_GSL="$(usex gsl)"
		-DDEAL_II_WITH_HDF5="$(usex hdf5)"
		-DDEAL_II_WITH_LAPACK="$(usex lapack)"
		-DDEAL_II_WITH_MAGIC_ENUM=ON
		-DDEAL_II_WITH_METIS="$(usex metis)"
		-DDEAL_II_WITH_MPI="$(usex mpi)"
		-DDEAL_II_WITH_MUMPS="$(usex mumps)"
		-DDEAL_II_WITH_MUPARSER="$(usex muparser)"
		-DDEAL_II_WITH_OPENCASCADE="$(usex opencascade)"
		-DDEAL_II_WITH_P4EST="$(usex p4est)"
		-DDEAL_II_WITH_PETSC="$(usex petsc)"
		-DDEAL_II_WITH_SCALAPACK="$(usex scalapack)"
		-DDEAL_II_WITH_SLEPC="$(usex slepc)"
		-DDEAL_II_WITH_SUNDIALS="$(usex sundials)"
		-DDEAL_II_WITH_SYMENGINE="$(usex symengine)"
		-DDEAL_II_WITH_TASKFLOW=ON
		-DDEAL_II_WITH_TBB=OFF
		-DDEAL_II_WITH_TRILINOS="$(usex trilinos)"
		-DDEAL_II_WITH_UMFPACK="$(usex sparse)"
		-DDEAL_II_WITH_VTK="$(usex vtk)"
		-DDEAL_II_WITH_ZLIB=ON
	)

	use opencascade && mycmakeargs+=(
		-DCMAKE_PREFIX_PATH="/usr/$(get_libdir)/opencascade"
	)

	# Do a little dance for purely cosmetic QA reasons. The build system
	# does query for the highest instruction set first and skips the other
	# variables if a "higher" variant is set
	if use cpu_flags_x86_avx512f; then
		mycmakeargs+=( -DDEAL_II_HAVE_AVX512=yes )
		append-cxxflags "-mavx512f"
	elif use cpu_flags_x86_avx; then
		mycmakeargs+=( -DDEAL_II_HAVE_AVX=yes )
		append-cxxflags "-mavx2"
	elif use cpu_flags_x86_avx; then
		mycmakeargs+=( -DDEAL_II_HAVE_SSE2=yes )
		append-cxxflags "-msse2"
	fi

	cmake_src_configure
}

src_install() {
	if use doc && [[ ${PV} != *9999* ]]; then
		# copy missing images to the build directory:
		cp -r "${WORKDIR}"/doc/doxygen/deal.II/images \
			"${BUILD_DIR}"/doc/doxygen/deal.II || die
		# replace links:
		sed -i \
			's#"http://www.dealii.org/images/steps/developer/\(step-.*\)"#"images/\1"#g' \
			"${BUILD_DIR}"/doc/doxygen/deal.II/step_*.html || die "sed failed"
	fi
	cmake_src_install

	# decompress the installed example sources:
	use examples && docompress -x /usr/share/doc/${PF}/examples
}
