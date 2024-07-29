# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="WebOb"
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="WSGI request and response object"
HOMEPAGE="
	https://webob.org/
	https://github.com/Pylons/webob/
	https://pypi.org/project/WebOb/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/legacy-cgi[${PYTHON_USEDEP}]
	' 3.13)
"

distutils_enable_sphinx docs 'dev-python/alabaster'
distutils_enable_tests pytest

src_prepare() {
	# py3.9
	sed -i -e 's:isAlive:is_alive:' tests/conftest.py || die
	distutils-r1_src_prepare
}
