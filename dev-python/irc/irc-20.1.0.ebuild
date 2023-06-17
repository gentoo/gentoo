# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="IRC client framework written in Python"
HOMEPAGE="
	https://github.com/jaraco/irc/
	https://pypi.org/project/irc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
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
	>=dev-python/setuptools-scm-3.4.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/scripts"
		dodoc -r scripts
	fi
	distutils-r1_python_install_all
}
