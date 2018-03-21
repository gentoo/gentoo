# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Ultra fast JSON encoder and decoder for Python"
HOMEPAGE="https://pypi.python.org/pypi/ujson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' -2)
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-sort_keys-segfault.patch"
	"${FILESDIR}/${P}-use-static-where-possible.patch"
	"${FILESDIR}/${P}-fix-for-overflowing-long.patch"
	"${FILESDIR}/${P}-standard-handling-of-none.patch"
	"${FILESDIR}/${P}-fix-ordering-of-orderdict.patch"
	"${FILESDIR}/${P}-test-depricationwarning.patch"
)

python_test() {
	"${PYTHON}" tests/tests.py || die
}
