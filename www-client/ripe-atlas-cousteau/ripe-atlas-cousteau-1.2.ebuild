# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN=${PN//-/.}
DESCRIPTION="A Python wrapper around the RIPE Atlas API"
HOMEPAGE="https://atlas.ripe.net/"
SRC_URI="mirror://pypi/${PN:0:1}/ripe.atlas.cousteau/ripe.atlas.cousteau-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_PN}-${PVR}"

DOCS=( CHANGES.rst README.rst )

RDEPEND="
	>=dev-python/socketio-client-0.6.5[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )"

python_test() {
	nosetests --verbose || die "Tests failed with ${EPYTHON}"
}
