# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="The official command-line client for RIPE Atlas"
HOMEPAGE="https://atlas.ripe.net/"
MY_GITHUB_AUTHOR="RIPE-NCC"
SRC_URI="https://github.com/${MY_GITHUB_AUTHOR}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRIC="!test? ( test )"

DOCS=( CHANGES.rst README.rst )

RDEPEND="
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=net-libs/ripe-atlas-sagan-1.2[${PYTHON_USEDEP}]
	>=www-client/ripe-atlas-cousteau-1.4[${PYTHON_USEDEP}]
	dev-python/ipy[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
	${RDEPEND}
"

python_install() {
	distutils-r1_python_install
	echo "RIPE Atlas Tools (Magellan) [Gentoo Linux] ${PVR}" > \
		${D}$(python_get_sitedir)/ripe/atlas/tools/user-agent
}

distutils_enable_tests nose
# Disabling doc for now, see
# https://github.com/RIPE-NCC/ripe-atlas-tools/issues/219
#distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
