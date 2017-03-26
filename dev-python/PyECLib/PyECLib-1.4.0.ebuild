# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils multilib

DESCRIPTION="Messaging API for RPC and notifications over a number of different messaging transports"
HOMEPAGE="https://pypi.python.org/pypi/PyECLib"
SRC_URI="mirror://pypi/p/pyeclib/pyeclib-${PV}.tar.gz"
S="${WORKDIR}/pyeclib-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"

CDEPEND="dev-libs/jerasure"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="dev-libs/liberasurecode
	${CDEPEND}"
