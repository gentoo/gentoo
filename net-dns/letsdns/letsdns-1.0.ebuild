# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Manage DANE TLSA records in DNS servers"
HOMEPAGE="https://letsdns.org"
SRC_URI="https://github.com/LetsDNS/letsdns/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

python_prepare_all() {
	echo -e '[options.packages.find]\nexclude=tests*' >>setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	export LOG_LEVEL=FATAL
	export UNITTEST_CONF=tests/citest.conf
	"${EPYTHON}" -m unittest discover
}
