# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Adds network extension support to python-novaclient"
HOMEPAGE="https://github.com/rackspace/os_networksv2_python_novaclient_ext"
SRC_URI="mirror://pypi/${PN:0:1}/os_networksv2_python_novaclient_ext/os_networksv2_python_novaclient_ext-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/os_networksv2_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-3.4.0[${PYTHON_USEDEP}]"
