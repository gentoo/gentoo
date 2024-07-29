# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Appendable key-value storage"
HOMEPAGE="
	https://github.com/dask/partd/
	https://pypi.org/project/partd/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/locket[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/versioneer-0.20[${PYTHON_USEDEP}]
	test? (
		dev-python/blosc[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.3[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
