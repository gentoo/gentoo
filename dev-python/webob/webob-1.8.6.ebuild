# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7,8,9}} )

inherit distutils-r1

MY_PN=WebOb
MY_P=${MY_PN}-${PV}

DESCRIPTION="WSGI request and response object"
HOMEPAGE="https://webob.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

distutils_enable_sphinx docs 'dev-python/alabaster'
distutils_enable_tests pytest

src_prepare() {
	# py3.9
	sed -i -e 's:isAlive:is_alive:' tests/conftest.py || die
	distutils-r1_src_prepare
}
