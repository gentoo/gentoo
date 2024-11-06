# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE='ncurses,sqlite(-)'
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Utility to monitor real time Tor status information"
HOMEPAGE="https://nyx.torproject.org"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.torproject.org/nyx.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
	inherit pypi
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	net-libs/stem[${PYTHON_USEDEP}]
	net-vpn/tor
"

distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all

	# bug #645336
	doman nyx.1
}
