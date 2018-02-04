# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Python wrapper for GNU Privacy Guard"
HOMEPAGE="http://pythonhosted.org/python-gnupg/ https://github.com/vsajip/python-gnupg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="app-crypt/gnupg"
DEPEND="${RDEPEND}"

# Tests are still hanging.
RESTRICT="test"

python_test() {
	# Note; 1 test fails under pypy only
	"${PYTHON}" test_gnupg.py || die "Tests fail with ${EPYTHON}"
}
