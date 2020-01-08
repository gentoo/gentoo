# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="python api for tmux"
HOMEPAGE="https://libtmux.git-pull.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${BDEPEND}
	test? (
		>=dev-python/pytest-4.5.0[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)"
RDEPEND="app-misc/tmux"

# tests aren't included in the dist tarball
RESTRICT="test"

python_test() {
	esetup.py test
}
