# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Multithreaded Click apps made easy."
HOMEPAGE="https://github.com/click-contrib/click-threading https://pypi.python.org/pypi/click-threading"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/click-5.0"
RDEPEND="${DEPEND}"

DOCS=( README.rst )
