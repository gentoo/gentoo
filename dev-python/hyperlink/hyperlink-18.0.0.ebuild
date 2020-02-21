# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7})

inherit distutils-r1

DESCRIPTION="A featureful, correct URL for Python"
HOMEPAGE="https://github.com/python-hyper/hyperlink https://pypi.org/project/hyperlink/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.9.2[${PYTHON_USEDEP}]
	)
"

python_test() {
	pytest -vv || die
}
