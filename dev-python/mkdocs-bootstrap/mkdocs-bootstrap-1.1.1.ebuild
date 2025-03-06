# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )
DISTUTILS_USE_PEP517=setuptools
DOCS_BUILDER="mkdocs"

inherit distutils-r1 docs

# No tag, use commit instead
COMMIT="70f2c3395adc3d64d6f9b6ff5bb01a4f0db72ed6"

DESCRIPTION="Bootstrap theme for MkDocs"
HOMEPAGE="https://www.mkdocs.org https://github.com/mkdocs/mkdocs-bootstrap"
SRC_URI="https://github.com/mkdocs/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/mkdocs"
