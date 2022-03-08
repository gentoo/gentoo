# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Library for analysis, compilation, synthesis, optimization of quantum circuits"
HOMEPAGE="https://github.com/boschmitt/tweedledum"
SRC_URI="https://github.com/boschmitt/tweedledum/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# >=dev-python/setuptools-42.0.0
# >=dev-python/wheel
# dev-util/ninja
BDEPEND="
	>=dev-util/cmake-3.18
	>=dev-python/scikit-build-0.12.0"

distutils_enable_tests pytest

python_compile() {
	local -x SKBUILD_CONFIGURE_OPTIONS="-DCMAKE_BUILD_TYPE=RelWithDebInfo"
	distutils-r1_python_compile
}

python_test() {
	epytest python/test
}
