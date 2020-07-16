# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="LZ4 Bindings for Python"
HOMEPAGE="https://pypi.org/project/lz4/ https://github.com/python-lz4/python-lz4"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="app-arch/lz4"
DEPEND="
	${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

# known test failure: https://github.com/python-lz4/python-lz4/issues/199
PATCHES=( "${FILESDIR}/lz4-3.0.2-test-fail-skip.patch"
)

distutils_enable_tests pytest
