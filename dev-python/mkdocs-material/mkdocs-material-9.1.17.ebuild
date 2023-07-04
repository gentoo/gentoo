# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-material-extensions
	dev-python/mkdocs-minify-plugin
	dev-python/mkdocs-redirects
"

inherit distutils-r1 docs

DESCRIPTION="A Material Design theme for MkDocs"
HOMEPAGE="
	https://github.com/squidfunk/mkdocs-material/
	https://pypi.org/project/mkdocs-material/
"
SRC_URI="
	https://github.com/squidfunk/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="social"

RDEPEND="
	>=dev-python/colorama-0.4[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.14[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-9.9.1[${PYTHON_USEDEP}]
	>=dev-python/regex-2022.4.24[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26[${PYTHON_USEDEP}]
	social? (
		>=dev-python/pillow-9.0[${PYTHON_USEDEP}]
		>=media-gfx/cairosvg-2.5[${PYTHON_USEDEP}]
	)
"

# mkdocs-material-extensions depends on mkdocs-material creating a circular dep
PDEPEND="
	>=dev-python/mkdocs-material-extensions-1.1.0[${PYTHON_USEDEP}]
"

PATCHES=(
	# simplify pyproject to remove extra deps for metadata
	"${FILESDIR}/${PN}-8.5.7-simplify-build.patch"
)

src_prepare() {
	echo "__version__ = '${PV}'" > gentoo_version.py || die
	distutils-r1_src_prepare
}
