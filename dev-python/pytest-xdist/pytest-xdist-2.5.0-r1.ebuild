# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Distributed testing and loop-on-failing modes"
HOMEPAGE="
	https://pypi.org/project/pytest-xdist/
	https://github.com/pytest-dev/pytest-xdist/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/execnet[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pytest-6.2.0[${PYTHON_USEDEP}]
	dev-python/pytest-forked[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/filelock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	# disable autoloading plugins in nested pytest calls
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# since we disabled autoloading, force loading necessary plugins
	local -x PYTEST_PLUGINS=xdist.plugin,xdist.looponfail,pytest_forked

	epytest
}
