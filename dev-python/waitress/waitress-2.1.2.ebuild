# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A pure-Python WSGI server"
HOMEPAGE="
	https://docs.pylonsproject.org/projects/waitress/en/latest/
	https://pypi.org/project/waitress/
	https://github.com/Pylons/waitress/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov::' setup.cfg || die
	distutils-r1_src_prepare
}
