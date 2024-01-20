# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_P=${P/_alpha/a}
DESCRIPTION="Sum Types, aka Tagged Unions, for Python"
HOMEPAGE="
	https://github.com/radix/sumtypes/
	https://pypi.org/project/sumtypes/
"
SRC_URI="
	https://github.com/radix/sumtypes/archive/${PV/_alpha/a}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~riscv ~s390 ~sparc"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
