# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Simple DNS resolver for asyncio"
HOMEPAGE="https://github.com/saghul/aiodns/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Tests fail with network-sandbox, since they try to resolve google.com
RESTRICT="test"

RDEPEND=">=dev-python/pycares-3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all

	#692720 apply https://github.com/saghul/aiodns/pull/73
	sed -e 's|typing; python_version<"3.7"|typing; python_version<"3.5"|' -i setup.py || die
}

python_test() {
	"${EPYTHON}" tests.py -v || die
}
