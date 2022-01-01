# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3)

inherit distutils-r1

DESCRIPTION="Validating URI References per RFC 3986"
HOMEPAGE="https://tools.ietf.org/html/rfc3986
	https://github.com/python-hyper/rfc3986
	https://rfc3986.rtfd.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="idna"

RDEPEND="
	idna? ( dev-python/idna[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? ( dev-python/idna[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
