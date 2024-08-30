# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/STEllAR-GROUP/hpx.git"
else
	SRC_URI="https://github.com/STEllAR-GROUP/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi
inherit check-reqs cmake multiprocessing python-single-r1

DESCRIPTION="C++ runtime system for parallel and distributed applications"
HOMEPAGE="https://hpx.stellar-group.org/"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="examples jemalloc mpi papi +perftools tbb zlib"
# tests fail to compile
RESTRICT="test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( jemalloc perftools tbb )
"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-cpp/asio-1.12.0
	dev-libs/boost:=
	sys-apps/hwloc:=
	jemalloc? ( dev-libs/jemalloc:= )
	mpi? ( virtual/mpi )
	papi? ( dev-libs/papi )
	perftools? ( dev-util/google-perftools:= )
	tbb? ( dev-cpp/tbb:= )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-python.patch"
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
		-DHPX_WITH_DOCUMENTATION=OFF
		-DHPX_WITH_PARCELPORT_MPI=$(usex mpi)
		-DHPX_WITH_PAPI=$(usex papi)
		-DHPX_WITH_GOOGLE_PERFTOOLS=$(usex perftools)
		-DHPX_WITH_COMPRESSION_ZLIB=$(usex zlib)
		-DHPX_WITH_TESTS=OFF
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
}

src_install() {
	cmake_src_install
	use examples && dodoc -r examples/
	python_fix_shebang "${ED}"
}
