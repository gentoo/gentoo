# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5} )

inherit distutils-r1

MY_PN=${PN/-/.}
DESCRIPTION="A simple python client for pushbullet.com"
HOMEPAGE="https://github.com/randomchars/pushbullet.py"
# tests and examples are missing from PyPI tarballs
# https://github.com/randomchars/pushbullet.py/pull/104
SRC_URI="https://github.com/randomchars/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND="
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

# Backport from upstream git
PATCHES=( "${FILESDIR}/${P}-fix-filetypes-python3.patch" )

python_test() {
	# skip tests which require network access
	PUSHBULLET_API_KEY= py.test \
		-k "not test_auth" || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		docinto examples
		dodoc -r example/.
	fi
	distutils-r1_python_install_all
}
