# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python library to aid in implementing HTTP Digest Authentication"
HOMEPAGE="https://pypi.org/project/python-digest/ https://bitbucket.org/akoha/python-digest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"
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
