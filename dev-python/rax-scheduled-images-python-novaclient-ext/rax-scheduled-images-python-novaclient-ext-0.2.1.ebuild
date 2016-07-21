# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Adds backup-schedule extension support to python-novaclient"
HOMEPAGE="https://github.com/rackspace/rax_backup_schedule_python_novaclient_ext"
SRC_URI="mirror://pypi/${PN:0:1}/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/rax_scheduled_images_python_novaclient_ext-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/python-novaclient-2.10.0[${PYTHON_USEDEP}]"
