# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

if [[ ${PV} != 9999 ]]; then
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
		https://bitbucket.org/blueluna/transmissionrpc/src/release-0.10/test/data/ubuntu-12.04.2-alternate-amd64.iso.torrent"
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

src_unpack() {
	unpack ${P}.tar.gz
	cp "${DISTDIR}/ubuntu-12.04.2-alternate-amd64.iso.torrent" ${P}/test/data/ || die
}

python_test() {
	esetup.py test
}
