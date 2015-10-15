# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="The oslo.versionedobjects library provides a generic versioned object model that is RPC-friendly."
HOMEPAGE="http://docs.openstack.org/developer/oslo.versionedobjects"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.versionedobjects/oslo.versionedobjects-${PV}.tar.gz"
S="${WORKDIR}/oslo.versionedobjects-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3-r1[${PYTHON_USEDEP}]"
