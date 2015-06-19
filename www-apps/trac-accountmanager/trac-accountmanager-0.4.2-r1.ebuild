# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/trac-accountmanager/trac-accountmanager-0.4.2-r1.ebuild,v 1.1 2015/06/04 12:43:52 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Trac plugin for manage user accounts"
HOMEPAGE="http://trac-hacks.org/wiki/AccountManagerPlugin"
SRC_URI="mirror://pypi/T/TracAccountManager/TracAccountManager-${PV}.tar.gz"

LICENSE="BSD BEER-WARE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=www-apps/trac-0.12"

S="${WORKDIR}/acct_mgr-${PV}"
