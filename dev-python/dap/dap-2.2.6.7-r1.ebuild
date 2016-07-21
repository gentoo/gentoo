# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Data Access Protocol client and server"
HOMEPAGE="http://pydap.org https://pypi.python.org/pypi/dap https://pypi.python.org/pypi/Pydap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="server"

RDEPEND="dev-python/httplib2[${PYTHON_USEDEP}]
	server? (
		dev-python/cheetah[${PYTHON_USEDEP}]
		dev-python/paste[${PYTHON_USEDEP}]
		dev-python/pastedeploy[${PYTHON_USEDEP}]
		dev-python/pastescript[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( docs/bugs docs/Changelog docs/history README TODO )

src_prepare() {
	sed -e "s/'dap.plugins'/'dap', 'dap.plugins'/" -i setup.py || die "sed failed"
	distutils-r1_src_prepare
}
