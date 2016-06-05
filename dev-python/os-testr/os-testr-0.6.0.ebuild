# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1

DESCRIPTION="A testr wrapper to provide functionality for OpenStack projects"
HOMEPAGE="https://pypi.python.org/pypi/os-testr https://github.com/openstack/os-testr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

CDEPEND="
	>=dev-python/pbr-1.3[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0[${PYTHON_USEDEP}]"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
	>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
	>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? ( ${RDEPEND}
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/ddt-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
