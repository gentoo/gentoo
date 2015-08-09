# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Command line twitter client"
HOMEPAGE="https://github.com/alejandrogomez/turses"
# NOTE: Remove the "-r1" from SRC_URI on the next version bump
SRC_URI="https://github.com/alejandrogomez/${PN}/archive/v${PV}.tar.gz -> ${P}-r1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tweepy[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS HISTORY.rst README.rst )

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
