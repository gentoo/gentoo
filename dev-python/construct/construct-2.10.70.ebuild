# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A powerful declarative parser for binary data"
HOMEPAGE="
	https://construct.readthedocs.io/en/latest/
	https://github.com/construct/construct/
	https://pypi.org/project/construct/
"
SRC_URI="
	https://github.com/construct/construct/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	test? (
		dev-python/arrow[${PYTHON_USEDEP}]
		dev-python/cloudpickle[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/lz4[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.15.4[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_benchmarks.py
)
