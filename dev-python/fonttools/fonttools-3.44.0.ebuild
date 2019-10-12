# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 virtualx

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="https://github.com/fonttools/fonttools/"
SRC_URI="https://github.com/fonttools/fonttools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]

		>=dev-python/fs-2.4.9[${PYTHON_USEDEP}]
		app-arch/brotli[python,${PYTHON_USEDEP}]
		app-arch/zopfli
	)"

python_test() {
	# virtualx used when matplotlib is installed causing plot module tests to run
	virtx pytest -vv Tests fontTools || die "pytest failed"
}
