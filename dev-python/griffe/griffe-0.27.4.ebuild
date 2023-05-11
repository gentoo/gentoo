# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=pdm

inherit distutils-r1

DESCRIPTION="Signature generator for Python programs"
HOMEPAGE="https://mkdocstrings.github.io/griffe/ https://pypi.org/project/griffe/"
# Tests need files absent from the PyPI tarballs
SRC_URI="https://github.com/mkdocstrings/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND=">=dev-python/colorama-0.4[${PYTHON_USEDEP}]"
BDEPEND="test? (
	>=dev-python/jsonschema-4.17.3[${PYTHON_USEDEP}]
	>=dev-python/pytest-xdist-2.4[${PYTHON_USEDEP}]
)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.27.4-build_backend.patch
)

distutils_enable_tests pytest
