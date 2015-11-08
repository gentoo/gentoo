# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="World timezone definitions for Python"
HOMEPAGE="http://pythonhosted.org/pytz/ https://pypi.python.org/pypi/pytz/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=sys-libs/timezone-data-2014i"
RDEPEND="${DEPEND}"

PATCHES=(
	# Use timezone-data zoneinfo.
	"${FILESDIR}"/${PN}-2009j-zoneinfo.patch
	# ...and do not install a copy of it.
	"${FILESDIR}"/${PN}-2009h-zoneinfo-noinstall.patch
)

python_test() {
	"${PYTHON}" pytz/tests/test_tzinfo.py -v || die "Tests fail with ${EPYTHON}"
}
