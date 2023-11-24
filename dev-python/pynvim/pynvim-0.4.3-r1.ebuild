# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Python client for Neovim"
HOMEPAGE="https://github.com/neovim/pynvim"
SRC_URI="https://github.com/neovim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"

RDEPEND="dev-python/msgpack[${PYTHON_USEDEP}]
	virtual/python-greenlet[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( app-editors/neovim )"

distutils_enable_tests pytest

python_prepare_all() {
	sed -r -i "s:[\"']pytest-runner[\"'](,|)::" setup.py || die
	distutils-r1_python_prepare_all
}
