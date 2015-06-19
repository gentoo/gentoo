# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/trac-accountmanager/trac-accountmanager-0.4.2.ebuild,v 1.1 2013/02/06 13:39:18 djc Exp $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="A Trac plugin for manage user accounts"
HOMEPAGE="http://trac-hacks.org/wiki/AccountManagerPlugin"
SRC_URI="mirror://pypi/T/TracAccountManager/TracAccountManager-${PV}.tar.gz"

LICENSE="BSD BEER-WARE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=">=www-apps/trac-0.12"

S="${WORKDIR}/acct_mgr-${PV}"
