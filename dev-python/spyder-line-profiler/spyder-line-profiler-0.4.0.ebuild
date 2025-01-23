# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 virtualx

DESCRIPTION="Plugin to run the python line profiler from within the spyder editor"
HOMEPAGE="
	https://github.com/spyder-ide/spyder-line-profiler/
	https://pypi.org/project/spyder-line-profiler/
"
SRC_URI="
	https://github.com/spyder-ide/spyder-line-profiler/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/line-profiler[${PYTHON_USEDEP}]
	dev-python/qtawesome[${PYTHON_USEDEP}]
	>=dev-python/spyder-6[${PYTHON_USEDEP}]
	<dev-python/spyder-7[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-qt[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	virtx epytest
}
