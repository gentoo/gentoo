# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-peewee/flask-peewee-0.6.5.ebuild,v 1.3 2015/01/16 03:42:51 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

RESTRICT="test" # broken

DESCRIPTION="Flask integration layer for the Peewee ORM"
HOMEPAGE="https://pypi.python.org/pypi/Flask-Admin"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/peewee[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)
	"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
