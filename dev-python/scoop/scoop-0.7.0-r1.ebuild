# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1

DESCRIPTION="Distributed Evolutionary Algorithms in Python"
HOMEPAGE="https://code.google.com/p/scoop/ https://pypi.python.org/pypi/scoop"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.release.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/greenlet-0.3.4
	>=dev-python/pyzmq-13.1.0"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${P}.release"
