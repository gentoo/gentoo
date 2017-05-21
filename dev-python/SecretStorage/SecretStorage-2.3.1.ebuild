# Copyright 2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Python bindings to FreeDesktop.org Secret Service API"
HOMEPAGE="http://pypi.python.org/pypi/SecretStorage"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]"
