# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DOCS_BUILDER="sphinx"
PYTHON_COMPAT=( python3_{10..12} )

DOCS_DIR="docs"

inherit distutils-r1 docs pypi

DESCRIPTION="RFC 3986-compliant URI parsing, classification and composition"
HOMEPAGE="
	https://github.com/tkem/uritools/
	https://pypi.org/project/uritools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv"

distutils_enable_tests pytest
