# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="unittest subTest() support and subtests fixture"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-subtests/
	https://pypi.org/project/pytest-subtests/"
SRC_URI="
	https://github.com/pytest-dev/pytest-subtests/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/pytest-7[${PYTHON_USEDEP}]
"
# pytest-xdist is used to test compatibility
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=xdist.plugin,xdist.looponfail,pytest_forked,pytest_subtests
	epytest
}
