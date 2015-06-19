# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyparted/pyparted-3.10-r1.ebuild,v 1.3 2014/12/09 09:42:41 jer Exp $

EAPI=5

PYTHON_COMPAT=(python{2_7,3_{3,4}})
inherit distutils-r1

DESCRIPTION="Python bindings for sys-block/parted"
HOMEPAGE="https://fedorahosted.org/pyparted/"
SRC_URI="https://fedorahosted.org/releases/p/y/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=">=sys-block/parted-3.1
	dev-python/decorator[${PYTHON_USEDEP}]
	sys-libs/ncurses"
DEPEND="virtual/pkgconfig
	${RDEPEND}"
# test? ( dev-python/pychecker )

src_test() {
	ewarn "Test suite disabled until dev-python/pychecker"
	ewarn "is migrated to -r1.eclass"
}
