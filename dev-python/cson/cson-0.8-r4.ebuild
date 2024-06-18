# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=pycson-${PV}
DESCRIPTION="A python parser for the Coffeescript Object Notation (CSON)"
HOMEPAGE="
	https://github.com/avakar/pycson/
	https://pypi.org/project/cson/
"
SRC_URI="
	https://github.com/avakar/pycson/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc ~riscv x86"

RDEPEND="
	dev-python/speg[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
