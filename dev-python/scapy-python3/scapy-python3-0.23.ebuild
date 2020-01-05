# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

IUSE="test"
RESTRICT="!test? ( test )"
inherit distutils-r1

DESCRIPTION="Packet crafting/sending/... PCAP processing tool with python3 compatibility"
HOMEPAGE="https://pypi.org/project/scapy-python3/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	!net-analyzer/scapy
	"
