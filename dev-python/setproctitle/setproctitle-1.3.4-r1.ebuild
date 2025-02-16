# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The package has a fallback implementation which is a noop but warns
# if the extensions weren't built, so we always build them.
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Allow customization of the process title"
HOMEPAGE="
	https://github.com/dvarrazzo/py-setproctitle/
	https://pypi.org/project/setproctitle/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# remove the override that makes extension builds non-fatal
	sed -i -e '/cmdclass/d' setup.py || die
}

src_configure() {
	# https://github.com/dvarrazzo/py-setproctitle/issues/145
	append-cflags -std=gnu17

	distutils-r1_src_configure
}
