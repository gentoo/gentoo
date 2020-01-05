# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="tmux session manager. built on libtmux"
HOMEPAGE="https://tmuxp.git-pull.com"
SRC_URI="https://github.com/tmux-python/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/kaptan[${PYTHON_USEDEP}]
	>=dev-python/libtmux-0.8[${PYTHON_USEDEP}]
	<dev-python/libtmux-0.9[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	<dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-4.1.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-rerunfailures-4.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	SHELL="/bin/bash" pytest -vv || die "Tests fail with ${EPYTHON}"
}
