# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Colored stream handler for the logging module"
HOMEPAGE="
	https://pypi.python.org/pypi/coloredlogs
	https://github.com/xolox/python-coloredlogs
	http://coloredlogs.readthedocs.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/humanfriendly-2.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/capturer-2.2[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.2[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/verboselogs-1.5[${PYTHON_USEDEP}]
	)"

DOCS=( README.rst )

PATCHES=( "${FILESDIR}"/${PN}-2.0-skip-cli-test.patch )

python_test() {
	# Sandbox violations
	sed \
		-e 's:test_system_logging:_&:g' \
		-e 's:test_syslog_shortcut_simple:_&:g' \
		-e 's:test_syslog_shortcut_enhanced:_&:g' \
		-i ${PN}/tests.py || die
	esetup.py test
}
