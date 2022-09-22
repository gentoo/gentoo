# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PN="${PN}_python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings to the mapbox earcut C++ library"
HOMEPAGE="https://github.com/skogler/mapbox_earcut_python"
# No tests in PyPI and GitHub release tarballs
SRC_URI="https://github.com/skogler/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="dev-python/pybind11[${PYTHON_USEDEP}]"

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest

S="${WORKDIR}"/${MY_P}
