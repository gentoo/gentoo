# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for HTML Tidy (tidylib)"
HOMEPAGE="http://countergram.com/open-source/pytidylib https://github.com/countergram/pytidylib"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="app-text/htmltidy"
DEPEND=${RDEPEND}

distutils_enable_tests pytest
