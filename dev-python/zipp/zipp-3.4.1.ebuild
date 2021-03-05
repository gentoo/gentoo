# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Backport of pathlib-compatible object wrapper for zip files"
HOMEPAGE="https://github.com/jaraco/zipp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

BDEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-3.4.2[${PYTHON_USEDEP}]
	test? ( dev-python/jaraco-itertools[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx docs \
	">=dev-python/jaraco-packaging-3.2" \
	">=dev-python/rst-linker-1.9"
distutils_enable_tests pytest

python_prepare_all() {
	# Skip a potentially flaky performance test
	sed -i -e '/^import func_timeout\|^ *@func_timeout\.func_set_timeout/d' \
		-e 's/test_implied_dirs_performance/_&/' test_zipp.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Ignoring zipp.py from ${S} avoids ImportPathMismatchError with Python < 3.8
	# by ensuring only zipp from ${BUILD_DIR} is loaded
	pytest --ignore zipp.py -vv || die "Tests fail with ${EPYTHON}"
}
