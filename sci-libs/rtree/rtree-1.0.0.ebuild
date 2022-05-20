# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PN="Rtree"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="R-Tree spatial index for Python GIS"
HOMEPAGE="https://rtree.readthedocs.io"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	sci-libs/libspatialindex
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

BDEPEND="
	test? ( dev-python/numpy[${PYTHON_USEDEP}] )
"
