# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1

# this is 2.6 + tests
EGIT_COMMIT=c6c8567a66f5ff8c5510755ca25a9bdd2756c4f6
MY_P=python-cgi-${EGIT_COMMIT}
DESCRIPTION="Fork of the standard library cgi and cgitb modules (deprecated)"
HOMEPAGE="
	https://github.com/jackrosenthal/python-cgi/
	https://pypi.org/project/legacy-cgi/
"
# no tests in sdist
SRC_URI="
	https://github.com/jackrosenthal/python-cgi/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest
