# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2

EGIT_REPO_URI="git://github.com/rackspace/os_diskconfig_python_novaclient_ext.git
	https://github.com/rackspace/os_diskconfig_python_novaclient_ext.git"

DESCRIPTION="Disk Config extension for python-novaclient"
HOMEPAGE="https://github.com/rackspace/os_diskconfig_python_novaclient_ext"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/os_diskconfig_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.10.0[${PYTHON_USEDEP}]"
