# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A library that provides a generic versioned and RPC-friendly  object model."
HOMEPAGE="http://docs.openstack.org/developer/oslo.versionedobjects"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.versionedobjects/oslo.versionedobjects-${PV}.tar.gz"
S="${WORKDIR}/oslo.versionedobjects-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.20.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.19.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-5.29.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.18.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-serialization-1.19.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.30.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/webob-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]"
