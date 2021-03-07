# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/STEllAR-GROUP/hpx.git"
else
	SRC_URI="https://github.com/STEllAR-GROUP/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi
inherit check-reqs cmake multiprocessing python-single-r1

DESCRIPTION="C++ runtime system for parallel and distributed applications"
HOMEPAGE="https://stellar.cct.lsu.edu/tag/hpx/"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="doc examples jemalloc mpi papi +perftools tbb test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( jemalloc perftools tbb )
"

BDEPEND="
	virtual/pkgconfig
	doc? (
		${PYTHON_DEPS}
		app-doc/doxygen
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_MULTI_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_MULTI_USEDEP}]
			dev-python/breathe[${PYTHON_MULTI_USEDEP}]
		')
	)
	test? ( ${PYTHON_DEPS} )
"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost:=
	sys-apps/hwloc
	sys-libs/zlib
	mpi? ( virtual/mpi )
	papi? ( dev-libs/papi )
	perftools? ( dev-util/google-perftools )
	tbb? ( dev-cpp/tbb )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
	"${FILESDIR}/${P}-docs.patch"
	"${FILESDIR}/${P}-python.patch"
	"${FILESDIR}/${P}-tests.patch"
)

hpx_memory_requirement() {
	# HPX needs enough main memory for compiling
	# rule of thumb: 1G per job
	if [[ -z ${MAKEOPTS} ]] ; then
		echo "2G"
	else
		local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")
		echo "${jobs}G"
	fi
}

pkg_pretend() {
	local CHECKREQS_MEMORY=$(hpx_memory_requirement)
	check-reqs_pkg_setup
}

pkg_setup() {
	local CHECKREQS_MEMORY=$(hpx_memory_requirement)
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DHPX_WITH_EXAMPLES=OFF
		-DHPX_WITH_DOCUMENTATION=$(usex doc)
		-DHPX_WITH_PARCELPORT_MPI=$(usex mpi)
		-DHPX_WITH_PAPI=$(usex papi)
		-DHPX_WITH_GOOGLE_PERFTOOLS=$(usex perftools)
		-DBUILD_TESTING=$(usex test)
	)
	if use jemalloc; then
		mycmakeargs+=( -DHPX_WITH_MALLOC=jemalloc )
	elif use perftools; then
		mycmakeargs+=( -DHPX_WITH_MALLOC=tcmalloc )
	elif use tbb; then
		mycmakeargs+=( -DHPX_WITH_MALLOC=tbbmalloc )
	else
		mycmakeargs+=( -DHPX_WITH_MALLOC=system )
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use test && cmake_build tests
}

src_test() {
	# avoid over-suscribing
	cmake_src_test -j1
}

src_install() {
	cmake_src_install
	use examples && dodoc -r examples/
	python_fix_shebang "${ED}"
}
