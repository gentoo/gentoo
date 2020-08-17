# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A pytest plugin to run Xvfb for tests"
HOMEPAGE="https://pypi.org/project/pytest-xvfb/"
SRC_URI="https://github.com/The-Compiler/pytest-xvfb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/pytest-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/pyvirtualdisplay-1.3[${PYTHON_USEDEP}]
	x11-base/xorg-server[xvfb]
"

distutils_enable_tests pytest

python_test() {
	distutils_install_for_testing
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
