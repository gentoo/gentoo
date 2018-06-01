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
IUSE="test"

COMMON_DEPEND="
	<dev-python/msgpack-0.5.2:0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.4.0:0[${PYTHON_USEDEP}]
	virtual/python-greenlet[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/trollius[${PYTHON_USEDEP}]' python2_7)"

RDEPEND="
	${COMMON_DEPEND}
	>=app-editors/neovim-0.1.6"

DEPEND="
	${COMMON_DEPEND}
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/python-client-${PV}"

python_test() {
	nosetests -d -v || die
}
