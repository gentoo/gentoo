# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-digest/python-digest-1.7-r1.ebuild,v 1.6 2015/04/08 08:05:12 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A Python library to aid in implementing HTTP Digest Authentication"
HOMEPAGE="http://pypi.python.org/pypi/python-digest/ https://bitbucket.org/akoha/python-digest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE="test"
DISTUTILS_IN_SOURCE_BUILD=1

LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

PATCHES=( "${FILESDIR}"/${P}-unittest.patch )

python_test() {
	"${PYTHON}" ${PN/-/_}/tests.py || die "Tests failed under ${EPYTHON}"
}
