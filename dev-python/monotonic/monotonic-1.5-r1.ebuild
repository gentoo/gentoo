# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="An implementation of time.monotonic() for Python 2 & < 3.3"
HOMEPAGE="https://github.com/atdt/monotonic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

# no tests
