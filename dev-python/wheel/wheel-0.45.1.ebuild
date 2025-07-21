# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A built-package format for Python"
HOMEPAGE="
	https://github.com/pypa/wheel/
	https://pypi.org/project/wheel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

# xdist is slightly flaky here
EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fails if any setuptools plugin imported the module first
	tests/test_bdist_wheel.py::test_deprecated_import

	# broken by setuptools license changes
	# upstream removed the tests already
	tests/test_bdist_wheel.py::test_licenses_default
	tests/test_bdist_wheel.py::test_licenses_deprecated
	tests/test_bdist_wheel.py::test_licenses_override
)

src_prepare() {
	local PATCHES=(
		# https://github.com/pypa/wheel/pull/651
		"${FILESDIR}/${P}-test.patch"
	)

	distutils-r1_src_prepare

	# unbundle packaging
	rm -r src/wheel/vendored || die
	find -name '*.py' -exec sed -i \
		-e 's:wheel\.vendored\.::' \
		-e 's:\.\+vendored\.::' {} + || die
}
