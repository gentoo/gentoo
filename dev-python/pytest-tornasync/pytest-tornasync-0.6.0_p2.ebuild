# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin for testing Python 3.5+ Tornado code"
HOMEPAGE="https://github.com/eukaryote/pytest-tornasync"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

# TODO: fix this
# E   ImportError: cannot import name 'MESSAGE' from 'test'
RESTRICT="test"

RDEPEND="
	>=dev-python/pytest-3.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# Do not install the license file
	sed -i -e '/LICENSE/d' setup.py || die

	distutils-r1_python_prepare_all
}
