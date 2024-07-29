# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A WSGI middleware that secures routes using HTTP Digest Authentication"
HOMEPAGE="
	https://github.com/jonashaag/httpauth/
	https://pypi.org/project/httpauth/
"
# 0.4 has broken sdist
# https://github.com/jonashaag/httpauth/issues/6
SRC_URI="
	https://github.com/jonashaag/httpauth/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
