# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Collection of small Python functions & classes"
HOMEPAGE="
	https://github.com/WoLpH/python-utils/
	https://pypi.org/project/python-utils/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	docs
	_python_utils_tests/test_logger.py
	python_utils/loguru.py
)

python_prepare_all() {
	sed -i -e '/--cov/d' -e '/--mypy/d' pytest.ini || die
	distutils-r1_python_prepare_all
}
