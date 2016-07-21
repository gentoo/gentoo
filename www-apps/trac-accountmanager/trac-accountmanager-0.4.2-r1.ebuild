# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
