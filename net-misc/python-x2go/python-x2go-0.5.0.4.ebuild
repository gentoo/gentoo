# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/python-x2go/python-x2go-0.5.0.4.ebuild,v 1.1 2015/08/02 20:03:25 voyageur Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="X2Go client-side Python API"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: minimal USE flag in net-misc/nx, we only need nxproxy/nxcomp
DEPEND="dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	net-misc/nx"
RDEPEND="${DEPEND}"
