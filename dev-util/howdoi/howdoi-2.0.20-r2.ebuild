# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1

DESCRIPTION="A code search tool"
HOMEPAGE="https://pypi.org/project/howdoi/"
# pypi sources do not contain test data
SRC_URI="
	https://github.com/gleitz/howdoi/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/cachelib[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/keep[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyquery-1.4.1[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_test() {
	# following variable disables colorization test, which does not work on non-tty output
	# see https://github.com/gleitz/howdoi/commit/c53b6a179a09159740de2c06fb87b194e810f839
	local -x GITHUB_ACTION=1
	distutils-r1_src_test
}
