# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Python wrapper for HTML Tidy (tidylib)"
HOMEPAGE="http://countergram.com/open-source/pytidylib https://github.com/countergram/pytidylib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="app-text/htmltidy"
DEPEND=${RDEPEND}

distutils_enable_tests pytest
