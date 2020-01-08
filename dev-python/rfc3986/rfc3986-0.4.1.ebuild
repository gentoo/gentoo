# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 pypy3)

inherit distutils-r1

DESCRIPTION="Validating URI References per RFC 3986"
HOMEPAGE="https://tools.ietf.org/html/rfc3986
	https://github.com/sigmavirus24/rfc3986
	https://rfc3986.rtfd.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND=""

python_test() {
	py.test -vv || die
}
