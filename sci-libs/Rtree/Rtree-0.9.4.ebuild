# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1

DESCRIPTION="R-Tree spatial index for Python GIS"
HOMEPAGE="https://rtree.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"

S=${WORKDIR}/${MY_P}

RDEPEND="sci-libs/libspatialindex"

distutils_enable_sphinx docs/source

distutils_enable_tests pytest
