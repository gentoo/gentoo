# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 pypy )
inherit distutils-r1

DESCRIPTION="Replacement for bz2.BZ2File with features from newest CPython"
HOMEPAGE="https://pypi.python.org/pypi/bz2file https://github.com/nvawda/bz2file"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x64-cygwin"
IUSE=""

python_test() {
	"${PYTHON}" test_bz2file.py -v || die "Tests fail with ${EPYTHON}"
}
