# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A connection pool for python-ldap"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8.0[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/oslo-config-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.3.0[${PYTHON_USEDEP}]
	dev-python/enum34[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.17.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/ordereddict/d' requirements.txt
	distutils-r1_python_prepare_all
}
