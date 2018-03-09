# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
inherit distutils-r1

DESCRIPTION="Python client for Neovim"
HOMEPAGE="https://github.com/neovim/python-client"
SRC_URI="https://github.com/neovim/python-client/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	virtual/python-greenlet[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/trollius[${PYTHON_USEDEP}]' python2_7)"

RDEPEND="
	${DEPEND}
	>=app-editors/neovim-0.2.1"

S="${WORKDIR}/python-client-${PV}"

python_prepare_all() {
	# allow useage of renamed msgpack
	sed -i '/^msgpack/d' setup.py || die
	distutils-r1_python_prepare_all
}
