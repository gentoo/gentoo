# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools

inherit cmake distutils-r1

DESCRIPTION="C++ Multi-format 1D/2D barcode image processing library"
HOMEPAGE="https://github.com/zxing-cpp/zxing-cpp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/${PN}/${PN}/releases/download/v${PV}/test_samples.tar.gz -> ${P}-test.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="python test"

DEPEND="python? ( dev-python/pybind11 )"
RDEPEND="${PYTHON_DEPS}"
BDEPEND="python? ( ${DISTUTILS_DEPS} )
	test? (
		dev-cpp/gtest
		dev-libs/stb
		dev-libs/libfmt
	)
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# https://github.com/zxing-cpp/zxing-cpp/issues/848
CMAKE_WARN_UNUSED_CLI=no
QA_PRESTRIPPED="usr/lib/python.*/site-packages/zxingcpp.cpython-.*.so"

src_prepare() {
	cmake_src_prepare

	if use python; then
		cd "${S}"/wrappers/python || die
		distutils-r1_src_prepare
	fi
}

src_configure() {
	# TODO: Next release deprecates -DBUILD_* and replaces it with -DZXING_*
	local mycmakeargs=(
		-DBUILD_DEPENDENCIES=LOCAL

		-DBUILD_EXAMPLES=OFF # nothing is installed

		-DBUILD_BLACKBOX_TESTS=$(usex test ON OFF)
		-DBUILD_UNIT_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure

	if use python; then
		cd "${S}"/wrappers/python || die
		# These would be nice to have, but since we're installing the library and python bindings
		# at the same time, it will find the previous version (or nothing on first install)
		# rather than the correct one we're building, so for now we build it once per python
		# -DBUILD_DEPENDENCIES=LOCAL
		# -DBUILD_SHARED_LIBS=ON
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		cd "${S}"/wrappers/python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

	if use python; then
		cd "${S}"/wrappers/python || die
		distutils-r1_src_install
	fi

}

src_test() {
	mv "${WORKDIR}/test/samples" "${WORKDIR}/${P}/test/samples" || die "Failed to move test samples"
	cmake_src_test --rerun-failed --output-on-failure
}
