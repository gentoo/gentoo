# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="An application to help with ebuild maintenance"
HOMEPAGE="http://dev.gentoo.org/~jokey/maintainer-helper"
SRC_URI="http://dev.gentoo.org/~jokey/maintainer-helper/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-qt/qtgui:4
	>=dev-python/PyQt4-4.2[X]
	>=sys-apps/pkgcore-0.3.1
	>=dev-python/snakeoil-0.1_rc2"

PYTHON_MODNAME="maintainer_helper"

pkg_postinst() {
	distutils_pkg_postinst
	elog "Currently gvim is hardcoded as editor, to change it, edit"
	elog "${EROOT}$(python_get_sitedir -b -f)/maintainer_helper/backend/tasks.py"
	elog "It will be a real setting in the next version"
}
