# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
DOCS_BUILDER="mkdocs"

inherit distutils-r1 docs

DESCRIPTION="Bootstrap theme for MkDocs"
HOMEPAGE="https://www.mkdocs.org https://github.com/mkdocs/mkdocs-bootstrap"
SRC_URI="https://github.com/mkdocs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/mkdocs"
