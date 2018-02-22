# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="HTTP/2 framing layer for Python"
HOMEPAGE="https://python-hyper.org/en/latest/ https://pypi.python.org/pypi/hyperframe"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
