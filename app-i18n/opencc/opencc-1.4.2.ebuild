# Copyright 2010-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit cmake distutils-r1

DESCRIPTION="Library for conversion between Traditional and Simplified Chinese characters"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
SRC_URI="https://github.com/BYVoid/OpenCC/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenCC-ver.${PV}"

LICENSE="Apache-2.0 BSD-2 jieba? ( MIT )"
SLOT="0/1.4"
KEYWORDS="~amd64 ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc jieba python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/marisa
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-cpp/tclap
	dev-libs/rapidjson
"
BDEPEND="${PYTHON_DEPS}
	doc? ( app-text/doxygen )
	python? (
		${DISTUTILS_DEPS}
		app-admin/chrpath
		$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
		test? ( $(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]') )
	)
	test? (
		dev-cpp/gtest
		!hppa? ( !sparc? ( dev-cpp/benchmark ) )
	)
"

DOCS=( AUTHORS NEWS.md README.md )

PATCHES=(
	"${FILESDIR}/${P}-python-reuse-cmake-clib.patch"
	"${FILESDIR}/${P}-drop-python-cli-entry-point.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# as of opencc 1.4.0 darts is mandatory, and the bundled darts has opencc specific fixes.
	find deps -mindepth 1 -maxdepth 1 -type d ! -name 'darts-clone-*' -exec rm -r {} + || die

	sed -e "s:\${DIR_SHARE_OPENCC}/doc:share/doc/${PF}:" -i doc/CMakeLists.txt || die

	cmake_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_OPENCC_JIEBA_PLUGIN=$(usex jieba)
		-DBUILD_PYTHON=$(usex python)
		-DENABLE_BENCHMARK=$(if use test && has_version -d dev-cpp/benchmark; then echo ON; else echo OFF; fi)
		-DENABLE_GTEST=$(usex test)
		-DUSE_SYSTEM_GOOGLE_BENCHMARK=ON
		-DUSE_SYSTEM_GTEST=ON
		-DUSE_SYSTEM_MARISA=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DUSE_SYSTEM_TCLAP=ON
	)

	cmake_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake_src_compile
	if use python; then
		cp "${BUILD_DIR}"/opencc_clib.*.so python/opencc/clib/ || die
		distutils-r1_src_compile
	fi
}

python_test() {
	epytest python/tests
}

src_test() {
	cmake_src_test
	if use python; then
		cd "${BUILD_DIR}_${EPYTHON}/install/usr/lib/${EPYTHON}/site-packages/opencc/clib" || die
		cmake --install "${BUILD_DIR}/data" --prefix "${PWD}" || die
		pushd "${S}" || die

		distutils-r1_src_test

		popd || die
		rm -r share/ || die
	fi
}

src_install() {
	cmake_src_install
	if use python; then
		distutils-r1_src_install

		# Hack to make opencc's python binding to use system opencc's configs
		dodir "/usr/lib/${EPYTHON}/site-packages/opencc/clib/share"
		dosym -r /usr/share/opencc "/usr/lib/${EPYTHON}/site-packages/opencc/clib/share/opencc"

		# Remove insecure RPATH
		chrpath --delete "${ED}/usr/lib/${EPYTHON}/site-packages/opencc/clib"/*.so || die
	fi
}
