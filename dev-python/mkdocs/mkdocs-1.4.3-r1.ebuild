# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Project documentation with Markdown"
HOMEPAGE="
	https://www.mkdocs.org/
	https://github.com/mkdocs/mkdocs/
	https://pypi.org/project/mkdocs/
"
SRC_URI="
	https://github.com/mkdocs/mkdocs/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"

# https://bugs.gentoo.org/873349
# Building documentation requires packaging: callouts and mkdocs-autorefs
#
# IUSE="doc"
#
# BDEPEND="
# 	doc? (
# 		$(python_gen_any_dep '
# 			dev-python/mdx-gh-links[${PYTHON_USEDEP}]
# 			dev-python/mkdocs-redirects[${PYTHON_USEDEP}]
# 		')
# 	)
# "
RDEPEND="
	>=dev-python/Babel-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.3.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-2.0[${PYTHON_USEDEP}]
	>=dev-python/ghp-import-1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml_env_tag-0.1[${PYTHON_USEDEP}]
	>=dev-python/importlib-metadata-4.3[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.5[${PYTHON_USEDEP}]
	>=dev-python/mergedeep-1.3.4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Tests fails if additional themes are installed
	mkdocs/tests/utils/utils_tests.py::UtilsTests::test_get_themes
	mkdocs/tests/utils/utils_tests.py::UtilsTests::test_get_themes_error
	mkdocs/tests/utils/utils_tests.py::UtilsTests::test_get_themes_warning

	# Does not work in emerge env
	mkdocs/tests/config/config_options_tests.py::ListOfPathsTest::test_paths_localized_to_config
)

python_prepare_all() {
	# livereload has been dropped in this release, this test is a remnant
	rm mkdocs/tests/livereload_tests.py || die

	# Does not work in emerge env
	sed -i -e 's/test_paths_localized_to_config/_&/' \
		mkdocs/tests/config/config_options_tests.py

	# unpin markdown
	# https://github.com/mkdocs/mkdocs/commit/562d5e14c1d2c914d42942ab2385822c04d5bc7b
	sed -i -e '/markdown/s:, <3.4::' pyproject.toml || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	default
# 	if use doc; then
# 		# cannot just do mkdocs build, because that fails if
# 		# the package isn't already installed
# 		python -m mkdocs build || die "Failed to make docs"
# 		# Colliding files found by ecompress:
# 		rm site/sitemap.xml.gz || die
# 		HTML_DOCS=( "site/." )
# 	fi
}

python_test() {
	epytest '-opython_files=*tests.py' mkdocs/tests
}
