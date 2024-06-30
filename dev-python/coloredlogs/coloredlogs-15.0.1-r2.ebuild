# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Colored stream handler for the logging module"
HOMEPAGE="
	https://pypi.org/project/coloredlogs/
	https://github.com/xolox/python-coloredlogs
	https://coloredlogs.readthedocs.io/en/latest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/humanfriendly-9.1[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/capturer[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/verboselogs[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-14.0-fix-install-prefix.patch"
	"${FILESDIR}/${PN}-15.0.1-py3.13.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# test_auto_install fails because the pth file isn't being loaded
	coloredlogs/tests.py::ColoredLogsTestCase::test_auto_install
)

python_test() {
	epytest coloredlogs/tests.py
}
