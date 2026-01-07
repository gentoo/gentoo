# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P="mapbox_earcut_python-${PV}"
DESCRIPTION="Python bindings to the mapbox earcut C++ library"
HOMEPAGE="
	https://github.com/skogler/mapbox_earcut_python/
	https://pypi.org/project/mapbox-earcut/
"
SRC_URI="
	https://github.com/skogler/mapbox_earcut_python/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

DEPEND="
	dev-python/numpy:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/nanobind-2.9.2[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

DOCS=( CHANGELOG.md README.md )

python_test() {
	rm -rf mapbox_earcut || die
	epytest
}
