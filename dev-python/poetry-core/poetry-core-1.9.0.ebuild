# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_TESTED=( pypy3 python3_{10..13} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1

DESCRIPTION="Poetry PEP 517 Build Backend"
HOMEPAGE="
	https://github.com/python-poetry/poetry-core/
	https://pypi.org/project/poetry-core/
"
SRC_URI="
	https://github.com/python-poetry/poetry-core/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

# check inside vendors/pyproject.toml
# (note that some are indirect deps)
RDEPEND="
	>=dev-python/fastjsonschema-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/lark-1.1.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-22.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/build[${PYTHON_USEDEP}]
			dev-python/pytest-mock[${PYTHON_USEDEP}]
			dev-python/tomli-w[${PYTHON_USEDEP}]
			>=dev-python/virtualenv-20.21[${PYTHON_USEDEP}]
			dev-vcs/git
		' "${PYTHON_TESTED[@]}")
	)
"

distutils_enable_tests pytest

src_prepare() {
	# remove vendoring of dependencies
	rm -r src/poetry/core/_vendor || die
	sed -e '/__vendor_site__/d' -i src/poetry/core/__init__.py || die

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# These "fail" bacause of glob file path resulting from newer versions
		# in our tree than vendored. But those don't affect anything.
		tests/masonry/builders/test_sdist.py::test_default_with_excluded_data
		tests/masonry/builders/test_wheel.py::test_default_src_with_excluded_data
	)

	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON} (unported deps)"
		return
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_mock
}
