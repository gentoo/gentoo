# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Bootswatch themes for MkDocs"
HOMEPAGE="https://www.mkdocs.org https://github.com/mkdocs/mkdocs-bootswatch"
SRC_URI="https://github.com/mkdocs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc"

DEPEND="dev-python/mkdocs"

python_compile_all() {
	default
	if use doc; then
		mkdocs build || die "Failed to make docs"
		# Colliding files found by ecompress:
		rm site/sitemap.xml.gz || die
		HTML_DOCS=( "site/." )
	fi
}
