# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Define boolean algebras, create and parse boolean expressions"
HOMEPAGE="
	https://pypi.org/project/boolean.py/
	https://github.com/bastikr/boolean.py/
"
SRC_URI="
	https://github.com/bastikr/boolean.py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

distutils_enable_tests pytest
