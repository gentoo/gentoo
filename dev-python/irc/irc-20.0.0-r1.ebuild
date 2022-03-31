# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="IRC client framework written in Python"
HOMEPAGE="https://github.com/jaraco/irc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND="
	dev-python/jaraco-collections[${PYTHON_USEDEP}]
	>=dev-python/jaraco-functools-1.20[${PYTHON_USEDEP}]
	>=dev-python/jaraco-itertools-1.8[${PYTHON_USEDEP}]
	dev-python/jaraco-logging[${PYTHON_USEDEP}]
	dev-python/jaraco-stream[${PYTHON_USEDEP}]
	dev-python/jaraco-text[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/tempora-1.6[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-3.4.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs '>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'
distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/scripts"
		dodoc -r scripts
	fi
	distutils-r1_python_install_all
}
