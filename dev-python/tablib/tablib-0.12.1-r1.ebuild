# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="A format-agnostic tabular dataset library written in Python"
HOMEPAGE="http://python-tablib.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-python/odfpy[${PYTHON_USEDEP}]
	dev-python/openpyxl[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/unicodecsv[${PYTHON_USEDEP}]
	dev-python/xlrd[${PYTHON_USEDEP}]
	dev-python/xlwt[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

# Test require >=dev-python/pandas-0.23 which is difficult to stabilize. At the
# time of this writing, we had to stabilize tablib due to a security bug, which
# is why we temporarily RESTRICT tests. Bug #659790
RESTRICT="test"

PATCHES=(
	# https://github.com/kennethreitz/tablib/issues/297
	"${FILESDIR}/${PN}-0.12.1-no-ujson.patch"
)

python_test() {
	pytest -v -v  || die
}
