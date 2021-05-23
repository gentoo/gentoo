# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python NTP library"
HOMEPAGE="https://pypi.org/project/ntplib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# tests fail with network-sandbox
PROPERTIES="test_network"
RESTRICT="test"

python_test() {
	"${EPYTHON}" ./test_ntplib.py -v || die
}
