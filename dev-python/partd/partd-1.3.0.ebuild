# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Appendable key-value storage"
HOMEPAGE="https://github.com/dask/partd/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/locket[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/blosc[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		dev-python/toolz[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
