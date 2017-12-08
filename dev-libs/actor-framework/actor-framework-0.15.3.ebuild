# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic cmake-multilib

bench_ref="d824310d2c0354c9d41fd0458eab88629dc29a94"
opencl_ref="cc4e4ef5ad92e3ee78e2f2897027e5f48cbc8e93"
python_ref="a754a79f193463fcbb712bafac098f8e2d85931e"

DESCRIPTION="The C++ Actor Framework (CAF)"
HOMEPAGE="https://actor-framework.org/"
SRC_URI="https://github.com/actor-framework/actor-framework/archive/${PV}.tar.gz -> ${P}.tar.gz
	benchmarks? ( https://github.com/actor-framework/opencl/archive/${opencl_ref}.tar.gz -> CAF_${PV}-benchmarks.tar.gz )
	opencl? ( https://github.com/actor-framework/opencl/archive/${opencl_ref}.tar.gz -> CAF_${PV}-opencl.tar.gz )
	python? ( https://github.com/actor-framework/python/archive/${python_ref}.tar.gz -> CAF_${PV}-python.tar.gz )"
LICENSE="|| ( Boost-1.0 BSD )"
SLOT="0/15.3"
KEYWORDS="~amd64 ~x86"
IUSE="benchmarks boost debug doc examples +mem_management opencl python static test tools"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="boost? ( dev-libs/boost[${MULTILIB_USEDEP}] )
	net-misc/curl[${MULTILIB_USEDEP}]
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )"

src_unpack() {
	unpack ${A}
	for i in opencl python; do
		if use ${i}; then
			mv "${i}"*/* "${S}/libcaf_${i}/" || die "died copying sources for ${i}"
		fi
	done
	if use benchmarks; then
		mv "${WORKDIR}/benchmarks-"* "${WORKDIR}/benchmarks" || die "died moving benchmarks"
	fi
}

src_prepare() {
	find "${S}" -name CMakeLists.txt \
		-exec sed -i 's#\(install(.* DESTINATION \)lib#\1${LIBRARY_OUTPUT_PATH}#g' \{\} + \
		|| die
	rm examples/CMakeLists.txt || die
	append-cxxflags "-std=c++11 -pthread -Wextra -Wall -pedantic"
	append-cflags "-std=c11 -pthread -Wextra -Wall -pedantic"

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCAF_USE_ASIO=$(usex boost)
		-DCAF_LOG_LEVEL=$(usex debug 3 0)
		-DCAF_ENABLE_RUNTIME_CHECKS=$(usex debug)
		-DCAF_ENABLE_ADDRESS_SANITIZER=$(usex debug)
		-DCAF_NO_MEM_MANAGEMENT=$(usex mem_management no yes)
		-DCAF_NO_OPENCL=$(usex opencl no yes)
		-DCAF_NO_PYTHON=$(usex python no yes)
		-DCAF_BUILD_STATIC=$(usex static)
		-DCAF_NO_BENCHMARKS=yes
		-DCAF_NO_TOOLS=$(usex tools no yes)
		-DCAF_NO_UNIT_TESTS=$(usex test no yes)
		-DLIBRARY_OUTPUT_PATH="$(get_libdir)"
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

	if use doc; then
		emake doc
	fi
}

multilib_src_install() {
	DOCS=( README.md )
	use examples && DOCS+=( "${S}/examples" )
	use benchmarks && DOCS+=( "${WORKDIR}/benchmarks/" )
	if use doc; then
		HTML_DOCS=( "${S}/html/"* )
	fi

	cmake-utils_src_install
}
