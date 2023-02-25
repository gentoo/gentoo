# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="
	dev-python/mkdocs-git-revision-date-localized-plugin
	dev-python/mkdocs-minify-plugin
	dev-python/mkdocs-material
	dev-python/pymdown-lexers
	dev-python/pyspelling
"
DOCS_INITIALIZE_GIT=1

inherit distutils-r1 docs

DESCRIPTION="Extensions for Python Markdown"
HOMEPAGE="
	https://github.com/facelessuser/pymdown-extensions/
	https://pypi.org/project/pymdown-extensions/
"
SRC_URI="
	https://github.com/facelessuser/pymdown-extensions/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

RDEPEND="
	>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/pygments-2.12.0[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile_all() {
	default
	# We need to do this manually instead of relying on docs_compile
	# https://bytemeta.vip/repo/facelessuser/pymdown-extensions/issues/1446
	# https://bugs.gentoo.org/859637
	if use doc; then
		python -m mkdocs build || die "Failed to make docs"
		# Colliding files found by ecompress:
		rm site/sitemap.xml.gz || die
		HTML_DOCS=( "site/." )
	fi
}
