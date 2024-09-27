# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

MY_P=rfc8785.py-${PV}
DESCRIPTION="Pure-Python impl. of RFC 8785 (JSON Canonicalization Scheme)"
HOMEPAGE="
	https://github.com/trailofbits/rfc8785.py/
	https://pypi.org/project/rfc8785/
"
SRC_URI="
	https://github.com/trailofbits/rfc8785.py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
