# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 git-r3

DESCRIPTION="Line-by-line profiler"
HOMEPAGE="https://github.com/rkern/line_profiler"
EGIT_REPO_URI="https://github.com/rkern/${PN}.git"

SLOT="0"
LICENSE="BSD"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	"

python_test() {
	"${PYTHON}" -m unittest discover -v "${S}"/tests/ \
		|| die "Tests failed with ${EPYTHON}"
}
