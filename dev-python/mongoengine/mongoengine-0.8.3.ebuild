# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mongoengine/mongoengine-0.8.3.ebuild,v 1.3 2015/01/16 03:36:29 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

RESTRICT="test" # connects to local DB and other nonsense

DESCRIPTION="A Python Object-Document-Mapper for working with MongoDB"
HOMEPAGE="https://github.com/MongoEngine/mongoengine/"
SRC_URI="https://github.com/MongoEngine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	"

src_prepare() {
	sed -i -e 's/tests/tests*/g' setup.py || die "Failed to fix test removal thingy"
}

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
