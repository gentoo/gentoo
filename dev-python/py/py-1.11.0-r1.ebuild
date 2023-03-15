# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="
	https://py.readthedocs.io/
	https://github.com/pytest-dev/py/
	https://pypi.org/project/py/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# This package is unmaintained and keeps being broken periodically.
RESTRICT=test

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
