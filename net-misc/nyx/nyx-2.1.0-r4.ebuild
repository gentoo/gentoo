# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE='ncurses,sqlite(-)'

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

RDEPEND="
	<net-libs/stem-1.8.0_p20211118[${PYTHON_USEDEP}]
	net-vpn/tor"

distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all

	# bug #645336
	doman nyx.1
}
