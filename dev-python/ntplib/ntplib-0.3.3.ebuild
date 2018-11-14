# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="Python NTP library"
HOMEPAGE="https://pypi.org/project/ntplib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# tests fail with network-sandbox
RESTRICT="test"

python_test() {
	"${PYTHON:-python}" ./test_ntplib.py
}
