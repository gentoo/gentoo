# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

MY_P=python-lhafile-${PV}
DESCRIPTION="LHA archive support for Python"
HOMEPAGE="
	https://github.com/FrodeSolheim/python-lhafile/
	https://pypi.org/project/lhafile/
"
SRC_URI="
	https://github.com/FrodeSolheim/python-lhafile/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
RESTRICT="test" # The tests don't work, they're probably outdated.
