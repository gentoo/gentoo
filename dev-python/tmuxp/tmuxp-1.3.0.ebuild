# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Tmux session manager built on libtmux"
HOMEPAGE="https://tmuxp.git-pull.com/"

SRC_URI="https://github.com/tony/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	app-misc/tmux
	=dev-python/libtmux-0.7.1[${PYTHON_USEDEP}]
	=dev-python/colorama-0.3.9[${PYTHON_USEDEP}]
	=dev-python/click-6.7[${PYTHON_USEDEP}]
	>=dev-python/kaptan-0.5.7[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	esetup.py test
}
