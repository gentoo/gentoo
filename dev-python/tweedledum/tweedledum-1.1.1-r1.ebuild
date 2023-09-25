# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Library for analysis, compilation, synthesis, optimization of quantum circuits"
HOMEPAGE="https://github.com/boschmitt/tweedledum"
SRC_URI="https://github.com/boschmitt/tweedledum/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
# Drop on next bump, see bug #858200
SRC_URI+=" https://github.com/boschmitt/tweedledum/commit/e73beb23a3feeba02a851e3f8131e3c85a29de2b.patch -> ${P}-fmt-e73beb23a3feeba02a851e3f8131e3c85a29de2b.patch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Unbundle dev-python/pybind11[${PYTHON_USEDEP}]?
RDEPEND="
	dev-cpp/nlohmann_json
	dev-libs/libfmt:=
"
DEPEND="
	${RDEPEND}
	dev-cpp/eigen
"
BDEPEND=">=dev-python/scikit-build-0.12.0"

PATCHES=(
	"${DISTDIR}"/${P}-fmt-e73beb23a3feeba02a851e3f8131e3c85a29de2b.patch
	"${FILESDIR}"/${PN}-1.1.1-gcc-13.patch
)

distutils_enable_tests pytest

python_compile() {
	# -DTWEEDLEDUM_USE_EXTERNAL_PYBIND11=ON
	local -x SKBUILD_CONFIGURE_OPTIONS="-DCMAKE_BUILD_TYPE=RelWithDebInfo"
	distutils-r1_python_compile
}

python_test() {
	epytest python/test
}
