# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A WSGI middleware that secures routes using HTTP Digest Authentication"
HOMEPAGE="
	https://github.com/jonashaag/httpauth/
	https://pypi.org/project/httpauth/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
