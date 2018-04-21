# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SQLAlchemy Schema Migration Tools"
HOMEPAGE="https://pypi.org/project/sqlalchemy-migrate/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.6[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-0.8[${PYTHON_USEDEP}]
	dev-python/tempita[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
# for tests: unittest2 and scripttest
