# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="pytest-twisted is a plugin for pytest that allows you to test code which uses the twisted framework"
HOMEPAGE="https://github.com/pytest-dev/pytest-twisted"
SRC_URI="https://github.com/pytest-dev/pytest-twisted/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# https://github.com/pytest-dev/pytest/issues/9280
	sed -e '/^pytest_plugins =/d' -i testing/conftest.py || die

	distutils-r1_src_prepare
}

python_test() {
	epytest -p pytester
}

src_install() {
	# If we let pytest-twisted autoload everywhere, it breaks tests in
	# packages that don't expect it. Apply a similar hack as for bug
	# #661218. We can't do this in src_prepare() because the tests need
	# autoloading enabled.
	sed -e 's/"pytest11": \[[^]]*\]//' -i setup.py || die

	distutils-r1_src_install
}
