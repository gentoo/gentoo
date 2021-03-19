# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Abstract Syntax Tree for logilab packages"
HOMEPAGE="https://github.com/PyCQA/astroid https://pypi.org/project/astroid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Version specified in __pkginfo__.py.
RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.11.2[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.4.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/astroid-2.4.2-no-pytest-runner.patch
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -r -e 's:"(wrapt|six|lazy_object_proxy)(~|=)=.+":"\1":' \
		-i astroid/__pkginfo__.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		# no clue why it's broken
		--deselect
		tests/unittest_modutils.py::GetModulePartTest::test_knownValues_get_builtin_module_part
	)
	[[ ${EPYTHON} == python3.9 ]] && deselect+=(
		--deselect
		tests/unittest_brain.py::TypingBrain::test_namedtuple_few_args
		--deselect
		tests/unittest_brain.py::TypingBrain::test_namedtuple_few_fields
		--deselect
		tests/unittest_brain.py::TypingBrain::test_namedtuple_inference_nonliteral
		--deselect
		tests/unittest_inference.py::test_dataclasses_subscript_inference_recursion_error
	)

	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
}
