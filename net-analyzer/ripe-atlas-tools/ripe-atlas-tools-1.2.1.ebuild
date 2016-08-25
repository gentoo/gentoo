# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

MY_PN=${PN//-/.}
DESCRIPTION="The official command-line client for RIPE Atlas"
HOMEPAGE="https://atlas.ripe.net/"
SRC_URI="mirror://pypi/${PN:0:1}/ripe.atlas.tools/ripe.atlas.tools-${PVR}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S="${WORKDIR}/${MY_PN}-${PVR}"

RDEPEND="
	>=net-libs/ripe-atlas-sagan-1.1.8[${PYTHON_USEDEP}]
	>=www-client/ripe-atlas-cousteau-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		"${RDEPEND}"
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )"

python_test() {
	nosetests --verbose || die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	echo "RIPE Atlas Tools (Magellan) [Gentoo Linux] ${PVR}" > \
		${D}$(python_get_sitedir)/ripe/atlas/tools/user-agent
}
