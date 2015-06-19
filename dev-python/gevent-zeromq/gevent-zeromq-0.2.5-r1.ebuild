# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gevent-zeromq/gevent-zeromq-0.2.5-r1.ebuild,v 1.5 2015/04/08 08:05:28 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="gevent_zeromq"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="Gevent compatibility layer for pyzmq"
HOMEPAGE="http://pypi.python.org/pypi/gevent_zeromq/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="~dev-python/pyzmq-2.2.0.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
