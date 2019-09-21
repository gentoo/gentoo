# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="tmux session manager. built on libtmux"
HOMEPAGE="https://tmuxp.git-pull.com"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? (
		>=dev-python/pytest-4.1.1[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}
	dev-python/kaptan[${PYTHON_USEDEP}]
	dev-python/libtmux[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]"

# tests currently failing, reported upstream
# https://github.com/tmux-python/tmuxp/issues/486
RESTRICT="test"

python_test() {
	SHELL="/bin/bash" py.test -v || die
}
