# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# deal.II uses its own FindLAPACK.cmake file that calls into the system
# FindLAPACK.cmake module and does additional internal setup. Do not remove
# any of these modules:
CMAKE_REMOVE_MODULES_LIST=""

inherit cmake flag-o-matic verify-sig

DESCRIPTION="Solving partial differential equations with the finite element method"
HOMEPAGE="https://www.dealii.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dealii/dealii.git"
	SRC_URI=""
else
	DOC_PV=9.4.1
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz
		verify-sig? ( https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz.asc )
		doc? (
			https://github.com/${PN}/${PN}/releases/download/v${DOC_PV}/${PN}-${DOC_PV}-offline_documentation.tar.gz
			verify-sig? ( https://github.com/${PN}/${PN}/releases/download/v${DOC_PV}/${PN}-${DOC_PV}-offline_documentation.tar.gz.asc )
			)"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="
	adolc arborx assimp arpack cgal cpu_flags_x86_avx cpu_flags_x86_avx512f
	cpu_flags_x86_sse2 cuda +debug doc +examples ginkgo gmsh +gsl hdf5
	+lapack metis mpi muparser opencascade p4est petsc scalapack slepc
	+sparse static-libs sundials symengine trilinos
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
	dev-cpp/tbb:=
	arborx? ( sci-libs/arborx[mpi=] )
	adolc? ( sci-libs/adolc )
	arpack? ( sci-libs/arpack[mpi=] )
	assimp? ( media-libs/assimp:= )
	cuda? ( dev-util/nvidia-cuda-toolkit )
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
	muparser? ( dev-cpp/muParser )
	opencascade? ( sci-libs/opencascade:= )
	p4est? ( sci-libs/p4est[mpi] )
	petsc? ( sci-mathematics/petsc[mpi=] )
	scalapack? ( sci-libs/scalapack )
	slepc? ( sci-mathematics/slepc[mpi=] )
	sparse? ( sci-libs/umfpack )
	sundials? ( sci-libs/sundials:= )
	symengine? ( >=sci-libs/symengine-0.4:= )
	trilinos? ( sci-libs/trilinos )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] dev-lang/perl )"

BDEPEND="
	verify-sig? ( <=sec-keys/openpgp-keys-dealii-20230904 )"

PATCHES=(
	"${FILESDIR}"/${PN}-9.1.1-no-ld-flags.patch
	"${FILESDIR}"/${PN}-9.4.2-base-mpi.cc-remove-superfluous-explicit-instantiatio.patch
	"${FILESDIR}"/${PN}-9.4.2-base-mpi.h-mark-a-template-variable-to-have-const-in.patch
)

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/dealii.asc"

src_configure() {
	# deal.II needs a custom build type:
	local CMAKE_BUILD_TYPE=$(usex debug DebugRelease Release)

	local mycmakeargs=(
		-DDEAL_II_PACKAGE_VERSION="${PV}"
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF
		-DDEAL_II_ALLOW_AUTODETECTION=OFF
		-DDEAL_II_ALLOW_BUNDLED=OFF
		-DDEAL_II_ALLOW_PLATFORM_INTROSPECTION=OFF
		-DDEAL_II_COMPILE_EXAMPLES=OFF
		-DDEAL_II_DOCHTML_RELDIR="share/doc/${P}/html"
		-DDEAL_II_DOCREADME_RELDIR="share/doc/${P}"
		-DDEAL_II_COMPILE_EXAMPLES=OFF
		-DDEAL_II_EXAMPLES_RELDIR="share/doc/${P}/examples"
		-DDEAL_II_LIBRARY_RELDIR="$(get_libdir)"
		-DDEAL_II_SHARE_RELDIR="share/${PN}"
		-DDEAL_II_WITH_ZLIB=ON
		-DDEAL_II_WITH_ADOLC="$(usex adolc)"
		-DDEAL_II_WITH_ARBORX="$(usex arborx)"
		-DDEAL_II_WITH_ASSIMP="$(usex assimp)"
		-DDEAL_II_WITH_ARPACK="$(usex arpack)"
		-DDEAL_II_WITH_CGAL="$(usex cgal)"
		-DDEAL_II_WITH_CUDA="$(usex cuda)"
		-DDEAL_II_WITH_GINKGO="$(usex ginkgo)"
		-DDEAL_II_COMPONENT_DOCUMENTATION="$(usex doc)"
		-DDEAL_II_COMPONENT_EXAMPLES="$(usex examples)"
		-DDEAL_II_WITH_GMSH="$(usex gmsh)"
		-DDEAL_II_WITH_GSL="$(usex gsl)"
		-DDEAL_II_WITH_HDF5="$(usex hdf5)"
		-DDEAL_II_WITH_KOKKOS="$(usex trilinos)"
		-DDEAL_II_WITH_LAPACK="$(usex lapack)"
		-DDEAL_II_WITH_METIS="$(usex metis)"
		-DDEAL_II_WITH_MPI="$(usex mpi)"
		-DDEAL_II_WITH_MUPARSER="$(usex muparser)"
		-DDEAL_II_WITH_OPENCASCADE="$(usex opencascade)"
		-DDEAL_II_WITH_P4EST="$(usex p4est)"
		-DDEAL_II_WITH_PETSC="$(usex petsc)"
		-DDEAL_II_WITH_SCALAPACK="$(usex scalapack)"
		-DDEAL_II_WITH_SLEPC="$(usex slepc)"
		-DDEAL_II_WITH_SUNDIALS="$(usex sundials)"
		-DDEAL_II_WITH_SYMENGINE="$(usex symengine)"
		-DDEAL_II_WITH_UMFPACK="$(usex sparse)"
		-DBUILD_SHARED_LIBS="$(usex !static-libs)"
		-DDEAL_II_PREFER_STATIC_LIBS="$(usex static-libs)"
		-DDEAL_II_WITH_TBB=ON
		-DDEAL_II_WITH_TASKFLOW=OFF
		-DDEAL_II_WITH_TRILINOS="$(usex trilinos)"
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

	# Unconditionally enable strict C++17 standard. This is necessary for
	# USE=cgal and USE=kokkos and safe to set for all presently supported
	# compilers
	append-cxxflags "-std=c++17"

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
