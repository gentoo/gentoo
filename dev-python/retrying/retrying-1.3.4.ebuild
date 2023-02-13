# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="General-purpose retrying library"
HOMEPAGE="
	https://github.com/groodt/retrying/
	https://pypi.org/project/retrying/
"
SRC_URI="
	https://github.com/groodt/retrying/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
