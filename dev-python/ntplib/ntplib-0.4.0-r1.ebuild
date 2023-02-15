# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python NTP library"
HOMEPAGE="
	https://github.com/cf-natali/ntplib/
	https://pypi.org/project/ntplib/
"
SRC_URI="
	https://github.com/cf-natali/ntplib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# tests fail with network-sandbox
PROPERTIES="test_network"
RESTRICT="test"

python_test() {
	"${EPYTHON}" ./test_ntplib.py -v || die
}
