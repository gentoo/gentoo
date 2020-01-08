# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7}} )

inherit distutils-r1

MY_PN=${PN//-/_}

DESCRIPTION="WebSocket client for python with hybi13 support"
HOMEPAGE="https://github.com/websocket-client/websocket-client"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~x64-macos"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' pypy python2_7 )
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	esetup.py test
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
