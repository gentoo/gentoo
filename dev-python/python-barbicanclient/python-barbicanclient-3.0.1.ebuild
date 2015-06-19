# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-barbicanclient/python-barbicanclient-3.0.1.ebuild,v 1.1 2014/11/18 23:10:02 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Client library for Barbican API."
HOMEPAGE="https://github.com/openstack/barbican"
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
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-0.11.2[${PYTHON_USEDEP}]
	>=dev-python/cliff-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.0.0[${PYTHON_USEDEP}]
"
