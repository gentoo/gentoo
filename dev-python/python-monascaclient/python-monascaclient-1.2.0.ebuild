# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Monasca API"
HOMEPAGE="https://github.com/openstack/python-monascaclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/oslo-config-3.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# built in...
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
