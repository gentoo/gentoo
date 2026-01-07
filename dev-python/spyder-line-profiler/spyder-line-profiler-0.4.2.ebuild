# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Plugin to run the python line profiler from within the spyder editor"
HOMEPAGE="
	https://github.com/spyder-ide/spyder-line-profiler/
	https://pypi.org/project/spyder-line-profiler/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/line-profiler[${PYTHON_USEDEP}]
	dev-python/qtawesome[${PYTHON_USEDEP}]
	=dev-python/spyder-6.1*[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-qt )
distutils_enable_tests pytest

python_test() {
	virtx epytest
}
