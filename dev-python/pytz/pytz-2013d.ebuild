# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytz/pytz-2013d.ebuild,v 1.12 2015/04/08 08:05:09 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} pypy )
inherit distutils-r1

DESCRIPTION="World timezone definitions for Python"
HOMEPAGE="http://pypi.python.org/pypi/pytz http://pytz.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=sys-libs/timezone-data-${PV}"
RDEPEND="${DEPEND}"

DOCS=( CHANGES.txt )

PATCHES=(
	# Use timezone-data zoneinfo.
	"${FILESDIR}/${PN}-2009j-zoneinfo.patch"
	# ...and do not install a copy of it.
	"${FILESDIR}/${PN}-2009h-zoneinfo-noinstall.patch"
)

python_test() {
	"${PYTHON}" pytz/tests/test_tzinfo.py
}
