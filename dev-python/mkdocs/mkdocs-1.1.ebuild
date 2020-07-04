# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Project documentation with Markdown."
HOMEPAGE="https://www.mkdocs.org https://github.com/mkdocs/mkdocs"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc"

BDEPEND="
	doc? (
		dev-python/mdx_gh_links
	)
"

RDEPEND="
	>=dev-python/click-3.3[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/livereload-2.5.1[${PYTHON_USEDEP}]
	~dev-python/lunr-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=www-servers/tornado-5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

python_prepare_all(){
	# cannot get all themes
	sed -i -e 's:test_get_themes:_&:' mkdocs/tests/utils/utils_tests.py || die

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
