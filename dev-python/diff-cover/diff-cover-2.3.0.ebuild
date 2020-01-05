# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Automatically find diff lines that need test coverage"
HOMEPAGE="https://github.com/Bachmann1234/diff-cover"
SRC_URI="https://github.com/Bachmann1234/diff-cover/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.1[${PYTHON_USEDEP}]
	dev-python/jinja2_pluralize[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/pycodestyle-2.4.0[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
	)"

MY_PN=${PN/-/_}
S=${WORKDIR}/${MY_PN}-${PV}

python_prepare_all() {
	# TypeError: test_parse_range_notation() takes exactly 2 arguments (1 given)
	sed -e 's|test_parse_range_notation|_\0|' \
		-i "${MY_PN}/tests/test_diff_cover_main.py" || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
