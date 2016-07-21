# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="A Twisted-based publish/subscribe messaging server that uses the STOMP protocol"
HOMEPAGE="https://pypi.python.org/pypi/morbid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="dev-python/stomper
	dev-python/twisted-core
	dev-python/twisted-web"
DEPEND="${RDEPEND}
	dev-python/setuptools"
