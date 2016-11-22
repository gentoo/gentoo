# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

if [[ ${PV} != 9999 ]]; then
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/blueluna/${PN}"
	KEYWORDS=""
fi

DESCRIPTION="Python module that implements the Transmission bittorrent client RPC protocol"
HOMEPAGE="https://bitbucket.org/blueluna/transmissionrpc"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=">=dev-python/six-1.1.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
