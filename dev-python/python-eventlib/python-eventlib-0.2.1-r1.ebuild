# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_REQ_USE="ssl"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Coroutine-based networking library"
HOMEPAGE="http://sipsimpleclient.org"
SRC_URI="http://download.ag-projects.com/SipClient/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-libressl.patch" )
