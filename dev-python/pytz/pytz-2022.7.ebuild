# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="World timezone definitions for Python"
HOMEPAGE="
	https://pythonhosted.org/pytz/
	https://launchpad.net/pytz/
	https://pypi.org/project/pytz/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND="
	|| (
		>=sys-libs/timezone-data-2017a
		sys-libs/glibc[vanilla]
	)
"
RDEPEND="${DEPEND}"

python_test() {
	"${EPYTHON}" pytz/tests/test_tzinfo.py -v ||
		die "Tests fail with ${EPYTHON}"
}
