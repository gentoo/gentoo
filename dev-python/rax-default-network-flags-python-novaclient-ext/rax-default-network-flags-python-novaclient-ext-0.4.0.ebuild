# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Disk Config extension for python-novaclient"
HOMEPAGE="https://github.com/rackspace/rax_default_network_flags_python_novaclient_ext"
SRC_URI="mirror://pypi/${PN:0:1}/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/rax_default_network_flags_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.20.0[${PYTHON_USEDEP}]"
