# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="PCAP BGP Parser"
HOMEPAGE="https://github.com/de-cix/pbgp-parser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/kafka-python[${PYTHON_USEDEP}]
	 dev-python/pcapy[${PYTHON_USEDEP}]"
