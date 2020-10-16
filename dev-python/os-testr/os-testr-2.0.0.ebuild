# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A testr wrapper to provide functionality for OpenStack projects"
HOMEPAGE="https://pypi.org/project/os-testr/ https://github.com/openstack/os-testr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"
RDEPEND="
	${CDEPEND}
	>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
	>=dev-python/subunit-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	test? ( ${RDEPEND}
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		!~dev-python/coverage-4.1[${PYTHON_USEDEP}]
		>=dev-python/oslotest-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/ddt-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
