# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/flask-mongoengine/flask-mongoengine-0.7.0.ebuild,v 1.3 2015/01/16 03:46:43 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

RESTRICT="test" # broken

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.python.org/pypi/flask-mongoengine/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/mongoengine[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)
	"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
