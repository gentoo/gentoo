# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_10 )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Create enumerated constants that are also subclasses of str"
HOMEPAGE="
	https://github.com/clbarnes/backports.strenum/
	https://pypi.org/project/backports.strenum/
"
# no tests in sdist
SRC_URI="
	https://github.com/clbarnes/backports.strenum/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

distutils_enable_tests pytest
