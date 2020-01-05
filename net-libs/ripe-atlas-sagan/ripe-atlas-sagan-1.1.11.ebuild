# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN=${PN//-/.}
DESCRIPTION="A parsing library for RIPE Atlas result strings"
HOMEPAGE="https://atlas.ripe.net/"
SRC_URI="mirror://pypi/${PN:0:1}/ripe.atlas.sagan/ripe.atlas.sagan-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"
DOCS=( CHANGES.rst README.rst )

S="${WORKDIR}/${MY_PN}-${PVR}"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests --verbose || die "Tests failed with ${EPYTHON}"
}
