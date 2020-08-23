# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6,7,8} pypy3)
PYTHON_REQ_USE='sqlite(-)'
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Utility to monitor real time Tor status information"
HOMEPAGE="https://nyx.torproject.org"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.torproject.org/nyx.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-libs/stem[${PYTHON_USEDEP}]
	net-vpn/tor"
