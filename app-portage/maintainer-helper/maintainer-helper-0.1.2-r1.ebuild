# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An application to help with ebuild maintenance"
HOMEPAGE="https://dev.gentoo.org/~jokey/maintainer-helper"
SRC_URI="https://dev.gentoo.org/~jokey/maintainer-helper/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-qt/qtgui:4
	>=dev-python/PyQt4-4.2[X,${PYTHON_USEDEP}]
	>=sys-apps/pkgcore-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/snakeoil-0.1_rc2[${PYTHON_USEDEP}]"

python_postinst() {
	elog "Currently gvim is hardcoded as editor, to change it, edit"
	elog "$(python_get_sitedir)/maintainer_helper/backend/tasks.py"
	elog "It will be a real setting in the next version"
}

pkg_postinst() { python_foreach_impl python_postinst; }
