# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 python3_7 )

inherit distutils-r1

DESCRIPTION="This package contains tools for authenticating to an OpenStack-based cloud."
HOMEPAGE="https://github.com/openstack/keystoneauth"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}1/${PN}1-${PV}.tar.gz"
S="${WORKDIR}/${PN}1-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/os-service-types-1.2.0[${PYTHON_USEDEP}]"
