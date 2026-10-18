# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Modules provided by dev-cpp/eigen
CMAKE_REMOVE_MODULES_LIST=( FindEigen3 )
inherit cmake cuda flag-o-matic multiprocessing

DESCRIPTION="C++ library for geometric algorithms and data structures"
HOMEPAGE="https://www.cgal.org/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN^^}/${PN}.git"
else
	SRC_URI="
		https://github.com/CGAL/cgal/releases/download/v${PV}/${P^^}.tar.xz
		doc? (
			https://github.com/CGAL/cgal/releases/download/v${PV}/${P^^}-doc_html.tar.xz
		)
	"
	S="${WORKDIR}/${P^^}"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="LGPL-3 GPL-3 Boost-1.0"
SLOT="0/14"

IUSE="demos doc examples test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	test? ( || (
		demos examples
	) )
"

# Referenced in the cmake files.
RDEPEND="
	dev-cpp/eigen:=
	dev-libs/boost:=
	dev-libs/gmp:=[cxx]
	dev-libs/mpfr:=
	virtual/zlib:=
"
DEPEND="${RDEPEND}
	test? (
		net-libs/libssh[server]
		demos? (
			dev-qt/qtbase:6[gui,opengl,widgets]
		)
		examples? (
			amd64? (
				media-gfx/openmesh
			)
			dev-qt/qtbase:6[gui,opengl,widgets]
		)
	)
"
BDEPEND="
	virtual/pkgconfig
"

pkg_pretend() {
	if ! use test && { use demos || use examples; }; then
		ewarn "The \"demos\" and \"examples\" useflag require USE=\"test\""
	fi
}

src_prepare() {
	if use doc; then
		rm -r "doc_html" || die
		mv "${WORKDIR}/doc_html" "${S}/" || die
	fi

	cmake_src_prepare
}

src_configure() {
	# Header only since 5.0

	local mycmakeargs=(
		-DCMAKE_POLICY_DEFAULT_CMP0167="NEW"

		-DCGAL_INSTALL_LIB_DIR="$(get_libdir)"
		-DCGAL_INSTALL_CMAKE_DIR="$(get_libdir)/cmake/CGAL"

		# https://github.com/CGAL/cgal/wiki/Testing#using-ctest
		-DCGAL_ENABLE_TESTING="$(usex test)"

		# Forcibly wipe to get rid of NDEBUG. see below
		-DCMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE^^}=""
	)

	if use test; then
		# include/CGAL/config.h:53:4: error: #error The test-suite needs no NDEBUG defined
		filter-flags -DNDEBUG*

		# cmake/modules/display-third-party-libs-versions.cmake
		# these need use flags eventually
		local deps=(
			Ceres
			GLPK
			# GMP
			ITK
			ITT
			LASLIB
			libpointmatcher
			METIS
			MPFI
			# MPFR
			OpenCV
			OpenGR
			OSQP
			SCIP
			SuiteSparse
			TBB
			VTK
			# ZLIB
		)

		if use demos || use examples; then
			# Optionally depends on sci-lib/vtk, which looks up a cuda compiler iff build with USE=cuda.
			# We therefore need to set the correct CUDAHOSTCXX and setup the sandbox.
			if has_version "sci-libs/vtk[cuda]" ; then
				cuda_add_sandbox
				addpredict "/dev/char/"
			fi

			deps+=(
				LEDA
				# MKL
				# RS
				# RS3
				SCIP
				# UMFPACK
			)
		fi

		if ! use demos; then
			deps+=(
				# Eigen3
			)
		fi

		if ! use demos && ! use examples; then
			deps+=(
				# Boost
				# Threads
				Qt6
			)
		fi

		if use examples; then
			deps+=(
				ESBTL
			)
		else
			deps+=(
				IPE
				LibSSH
				OpenMesh
			)
		fi

		mycmakeargs+=(
			-DCGAL_CTEST_DISPLAY_MEM_AND_TIME="yes"
			# exits some tests early
			-DCGAL_TEST_SUITE="yes"
			-DCGAL_TEST_DRAW_FUNCTIONS="yes"
			-DCGAL_DISABLE_GMP="no"
			# -DCGAL_WITH_benchmark="$(usex test "$(usex benchmark)")" # wired up but not present
			-DCGAL_WITH_demos="$(usex test "$(usex demos)")"
			-DCGAL_WITH_examples="$(usex test "$(usex examples)")"
		)
		if [[ -n "${deps[@]}" ]]; then
			mycmakeargs+=(
				# 964750
				# this does not work as demos and examples are separate cmake calls that ignore mycmakeargs
				$(printf -- "-DCMAKE_DISABLE_FIND_PACKAGE_%s=yes " "${deps[@]}")
			)
		fi
	fi

	cmake_src_configure
}

src_compile() {
	if use test; then
		if use demos; then
			cmake_src_compile demos
		fi

		if use examples; then
			cmake_src_compile examples
		fi

		cmake_src_compile ALL_CGAL_TARGETS
	fi
}

src_test() {
	# tests have split compilation & execution stages that do not depend on each other, but break when run out of order
	# We pass CMAKE_BUILD_PARALLEL_LEVEL to run compilation tests in parallel
	local -x CMAKE_BUILD_PARALLEL_LEVEL="$(get_makeopts_jobs)"
	einfo "using CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL}"

	# We pass CTEST_PARALLEL_LEVEL to run execution tests in parallel
	local -x CTEST_PARALLEL_LEVEL="$(get_makeopts_jobs)"
	einfo "using CTEST_PARALLEL_LEVEL=${CTEST_PARALLEL_LEVEL}"

	local -x QT_QPA_PLATFORM="offscreen"

	local CMAKE_SKIP_TESTS=(
		region_growing_planes_on_point_set_3
	)

	cmake_src_test -j1
}

src_install() {
	if use doc; then
		local HTML_DOCS=(
			"doc_html/."
		)
	fi

	cmake_src_install

	if use demos; then
		dodoc -r demo
	fi

	if use examples; then
		dodoc -r examples
	fi
}
