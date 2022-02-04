# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Colored stream handler for the logging module"
HOMEPAGE="
	https://pypi.org/project/coloredlogs/
	https://github.com/xolox/python-coloredlogs
	https://coloredlogs.readthedocs.io/en/latest/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

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

PATCHES=( "${FILESDIR}/coloredlogs-14.0-fix-install-prefix.patch" )

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	# test_cli_conversion requires the package to be installed
	distutils_install_for_testing
	# test_auto_install fails because the pth file isn't being loaded
	epytest coloredlogs/tests.py \
		--deselect coloredlogs/tests.py::ColoredLogsTestCase::test_auto_install
}
