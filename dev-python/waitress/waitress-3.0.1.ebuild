# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A pure-Python WSGI server"
HOMEPAGE="
	https://docs.pylonsproject.org/projects/waitress/en/latest/
	https://pypi.org/project/waitress/
	https://github.com/Pylons/waitress/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fails on some systems, https://bugs.gentoo.org/782031
	tests/test_wasyncore.py::DispatcherWithSendTests::test_send
)

src_prepare() {
	sed -i -e 's:--cov::' setup.cfg || die
	distutils-r1_src_prepare
}
