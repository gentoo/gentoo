# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

MY_PN="${PN//-/}"

DESCRIPTION="OpenStack Sphinx Extensions"
HOMEPAGE="http://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE=""

# NOTE: dev-python/hacking is unecessary as there are no tests

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]
"
RDEPEND=""
