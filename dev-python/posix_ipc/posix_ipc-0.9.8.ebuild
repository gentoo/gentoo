# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/posix_ipc/posix_ipc-0.9.8.ebuild,v 1.4 2015/07/07 15:57:35 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="POSIX IPC primitives (semaphores, shared memory and message queues) for Python"
HOMEPAGE="http://semanchuk.com/philip/posix_ipc/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND=""
