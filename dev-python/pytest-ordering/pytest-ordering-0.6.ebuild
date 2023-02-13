# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="pytest plugin to run your tests in a specific order"
HOMEPAGE="
	https://github.com/ftobia/pytest-ordering/
	https://pypi.org/project/pytest-ordering/
"
SRC_URI="https://github.com/ftobia/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-fix-pytest-6.patch"
)

distutils_enable_tests --install pytest
distutils_enable_sphinx docs/source

python_prepare_all() {
	# TypeError: `args` parameter expected to be a list or tuple of strings, got: '--markers' (type: <class 'str'>)
	sed -i -e 's:test_run_marker_registered:_&:' \
			tests/test_ordering.py || die

	distutils-r1_python_prepare_all
}
