# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_PN=${PN/-/.}
DESCRIPTION="A simple python client for pushbullet.com"
HOMEPAGE="https://github.com/randomchars/pushbullet.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	# skip tests which require network access
	PUSHBULLET_API_KEY= pytest -vv \
		-k "not (test_auth or test_decryption)" \
		|| die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r example/.
	fi
	distutils-r1_python_install_all
}
