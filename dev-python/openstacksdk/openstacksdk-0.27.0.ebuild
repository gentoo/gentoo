# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A collection of libraries for building applications to work with OpenStack."
HOMEPAGE="https://github.com/openstack/python-openstacksdk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/requestsexceptions-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/jsonpatch-1.16[${PYTHON_USEDEP}]
	!~dev-python/jsonpatch-1.20[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/os-service-types-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.13.0[${PYTHON_USEDEP}]
	>=dev-python/munch-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.9.0[${PYTHON_USEDEP}]
	virtual/python-ipaddress[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.1.0[${PYTHON_USEDEP}]
"
