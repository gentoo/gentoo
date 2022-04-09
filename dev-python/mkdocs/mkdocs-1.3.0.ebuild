# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Project documentation with Markdown"
HOMEPAGE="https://www.mkdocs.org https://github.com/mkdocs/mkdocs"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

IUSE="doc"

BDEPEND="
	doc? (
		$(python_gen_any_dep '
			dev-python/mdx_gh_links[${PYTHON_USEDEP}]
			dev-python/mkdocs-redirects[${PYTHON_USEDEP}]
		')
	)
"

RDEPEND="
	>=dev-python/Babel-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/click-3.3[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.2[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/watchdog-2.0[${PYTHON_USEDEP}]
	>=dev-python/ghp-import-1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml_env_tag-0.1[${PYTHON_USEDEP}]
	>=dev-python/importlib_metadata-3.10[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.5[${PYTHON_USEDEP}]
	>=dev-python/mergedeep-1.3.4[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

python_prepare_all() {
	# Tests fails if additional themes are installed
	sed -i -e 's:test_get_themes:_&:' \
		mkdocs/tests/utils/utils_tests.py || die

	# Skip this network test, "does not appear to be an IPv4 or IPv6 address"
	sed -i -e 's/test_IP_normalization/_&/' \
		mkdocs/tests/config/config_options_tests.py || die

	# livereload has been dropped in this release, this test is a remnant
	rm mkdocs/tests/livereload_tests.py || die

	# fix apparent typo in test (importing wrong thing)
	sed -i -e 's/from localization import/from mkdocs.localization import/g' \
		mkdocs/tests/theme_tests.py || die

	# Does not work in emerge env
	sed -i -e 's/test_paths_localized_to_config/_&/' \
		mkdocs/tests/config/config_options_tests.py

	distutils-r1_python_prepare_all
}

python_compile_all() {
	default
	if use doc; then
		# cannot just do mkdocs build, because that fails if
		# the package isn't already installed
		python -m mkdocs build || die "Failed to make docs"
		# Colliding files found by ecompress:
		rm site/sitemap.xml.gz || die
		HTML_DOCS=( "site/." )
	fi
}
