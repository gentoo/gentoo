# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

MY_PN="${PN^}"
DESCRIPTION="GPU-accelerated attack against WPA-PSK authentication"
HOMEPAGE="https://github.com/JPaulMora/Pyrit"
SRC_URI="https://github.com/JPaulMora/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda opencl test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/openssl
	net-libs/libpcap
	test? ( >=net-analyzer/scapy-2[${PYTHON_USEDEP}] )"
RDEPEND=">=net-analyzer/scapy-2
	opencl? ( net-wireless/cpyrit-opencl )
	cuda? ( net-wireless/cpyrit-cuda )"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_test() {
	cd test
	"${PYTHON}" test_pyrit.py
}
