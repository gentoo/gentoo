# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sqlalchemy-migrate/sqlalchemy-migrate-0.7.2-r1.ebuild,v 1.12 2015/05/15 07:12:19 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="SQLAlchemy Schema Migration Tools"
HOMEPAGE="http://code.google.com/p/sqlalchemy-migrate/ http://pypi.python.org/pypi/sqlalchemy-migrate"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ~ia64 ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

DEPEND="dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.6[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-0.8[${PYTHON_USEDEP}]
	dev-python/tempita[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
# for tests: unittest2 and scripttest
