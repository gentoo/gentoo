# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/glance_store/glance_store-0.1.10.ebuild,v 1.1 2014/11/18 22:13:50 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A connection pool for python-ldap"
HOMEPAGE="http://launchpad.net/oslo"
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
	>=dev-python/oslo-config-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-0.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-0.12[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
"
