# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A pytest plugin for testing Twisted framework consumers"
HOMEPAGE="https://github.com/pytest-dev/pytest-twisted"
SRC_URI="https://github.com/pytest-dev/pytest-twisted/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# If we let pytest-twisted autoload everywhere, it breaks tests in
	# packages that don't expect it. Apply a similar hack as for bug
	# #661218.
	sed -e 's/"pytest11": \[[^]]*\]//' -i setup.py || die

	# https://github.com/pytest-dev/pytest/issues/9280
	sed -e '/^pytest_plugins =/d' -i testing/conftest.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_twisted

	epytest -p pytester
}
