# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Namespace control and lazy-import mechanism"
HOMEPAGE="https://pypi.org/project/apipkg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-pytest-4.patch
)

distutils_enable_tests pytest
