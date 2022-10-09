# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# this is a backport, please do not add newer impls unless necessary
PYTHON_COMPAT=( pypy3 python3_{8..9} )

inherit distutils-r1

MY_P=${P/_p/-post}
DESCRIPTION="Backport of pathlib aiming to support the full stdlib Python API"
HOMEPAGE="
	https://pypi.org/project/pathlib2/
	https://github.com/jazzband/pathlib2/
"
SRC_URI="
	https://github.com/jazzband/pathlib2/archive/${PV/_p/-post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
