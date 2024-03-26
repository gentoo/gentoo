# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A python utility/library to sort imports"
HOMEPAGE="
	https://github.com/PyCQA/isort/
	https://pypi.org/project/isort/
"
SRC_URI="
	https://github.com/PyCQA/isort/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/natsort[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest

src_prepare() {
	# unbundle tomli
	sed -i -e 's:from ._vendored ::' isort/settings.py || die
	rm -r isort/_vendored || die

	distutils-r1_src_prepare
}

python_test() {
	cp -a "${BUILD_DIR}"/{install,test} || die
	local -x PATH=${BUILD_DIR}/test/usr/bin:${PATH}

	# Install necessary plugins
	local p
	for p in example*/; do
		pushd "${p}" >/dev/null || die
		distutils_pep517_install "${BUILD_DIR}"/test
		popd >/dev/null || die
	done

	local EPYTEST_DESELECT=(
		# relies on black 23.* output
		tests/unit/profiles/test_black.py::test_black_pyi_file
		# pytest-8
		tests/unit/test_ticketed_features.py::test_isort_should_warn_on_empty_custom_config_issue_1433
	)
	local EPYTEST_IGNORE=(
		# Excluded from upstream's test script
		tests/unit/test_deprecated_finders.py
	)

	if ! has_version "dev-python/pylama[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=(
			tests/unit/test_importable.py
			tests/unit/test_pylama_isort.py
		)
	fi

	epytest tests/unit
}
