# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

MY_P=MyST-Parser-${PV}
DESCRIPTION="Extended commonmark compliant parser, with bridges to Sphinx"
HOMEPAGE="
	https://github.com/executablebooks/MyST-Parser/
	https://pypi.org/project/myst-parser/
"
SRC_URI="
	https://github.com/executablebooks/MyST-Parser/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	https://github.com/executablebooks/MyST-Parser/pull/811.patch
		-> ${P}-sphinx-7.2.patch
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	<dev-python/markdown-it-py-4[${PYTHON_USEDEP}]
	>=dev-python/markdown-it-py-3.0[${PYTHON_USEDEP}]
	<dev-python/mdit-py-plugins-0.5[${PYTHON_USEDEP}]
	>=dev-python/mdit-py-plugins-0.4[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	<dev-python/sphinx-8[${PYTHON_USEDEP}]
	>=dev-python/sphinx-6[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		<dev-python/linkify-it-py-3[${PYTHON_USEDEP}]
		>=dev-python/linkify-it-py-2.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
		dev-python/pytest-param-files[${PYTHON_USEDEP}]
		>=dev-python/sphinx-7.2.6[${PYTHON_USEDEP}]
		dev-python/sphinx-pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/executablebooks/MyST-Parser/pull/811
		"${DISTDIR}/${P}-sphinx-7.2.patch"
	)

	default

	# unpin docutils
	sed -i -e '/docutils/s:,<[0-9.]*::' pyproject.toml || die
}

python_test() {
	local EPYTEST_DESELECT=()

	if has_version ">=dev-python/sphinx-7.3"; then
		EPYTEST_DESELECT+=(
			# https://github.com/executablebooks/MyST-Parser/issues/913
			'tests/test_renderers/test_fixtures_sphinx.py::test_syntax_elements[298-Sphinx Role containing backtick:]'
			'tests/test_renderers/test_fixtures_sphinx.py::test_sphinx_directives[341-versionadded (`sphinx.domains.changeset.VersionChange`):]'
			tests/test_sphinx/test_sphinx_builds.py::test_references_singlehtml
			tests/test_sphinx/test_sphinx_builds.py::test_heading_slug_func
			tests/test_sphinx/test_sphinx_builds.py::test_gettext_html
		)
	fi

	epytest
}
