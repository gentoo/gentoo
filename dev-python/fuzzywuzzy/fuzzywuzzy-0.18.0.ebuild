# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Fuzzy string matching in python"
HOMEPAGE="https://github.com/seatgeek/fuzzywuzzy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/pycodestyle[${PYTHON_USEDEP}] )"
RDEPEND="${PYTHON_DEPS}
	dev-python/python-levenshtein[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" test_fuzzywuzzy.py || die "tests failed under ${EPYTHON}"
}
