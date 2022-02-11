# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Poetry PEP 517 Build Backend"
HOMEPAGE="https://pypi.org/project/poetry-core/ https://github.com/python-poetry/poetry-core"
SRC_URI="
	https://github.com/python-poetry/poetry-core/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc ~x86"

# check inside src/poetry/core/_vendor/vendor.txt
RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/lark-parser[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pyrsistent[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pep517[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Those "fail" bacause of glob file path resulting from newer versions
	# in our tree than vendored. But those don't affect anything.
	tests/masonry/builders/test_sdist.py::test_default_with_excluded_data
	tests/masonry/builders/test_wheel.py::test_default_src_with_excluded_data
)

src_prepare() {
	# remove vendoring of dependencies
	rm -r poetry/core/_vendor || die
	sed -e '/__vendor_site__/d' -i poetry/core/__init__.py || die

	distutils-r1_src_prepare
}
