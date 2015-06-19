# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/asyncio/asyncio-3.4.2.ebuild,v 1.6 2015/05/27 08:37:34 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python3_{3,4} )

inherit distutils-r1

DESCRIPTION="reference implementation of PEP 3156"
HOMEPAGE="http://pypi.python.org/pypi/asyncio https://github.com/python/asyncio"
SRC_URI="mirror://pypi/a/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
