# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python implementation of RFC6570, URI Template"
HOMEPAGE="https://pypi.python.org/pypi/uritemplate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/simplejson[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.3"
DEPEND="${RDEPEND}"
