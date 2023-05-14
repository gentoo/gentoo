# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=pdm

inherit distutils-r1

DESCRIPTION="Python handler for dev-python/mkdocstrings"
HOMEPAGE="https://mkdocstrings.github.io/python/ https://pypi.org/project/mkdocstrings-python/"
# Tests need files absent from the PyPI tarballs
SRC_URI="https://github.com/mkdocstrings/python/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="dev-python/griffe[${PYTHON_USEDEP}]
	dev-python/mkdocstrings[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/mkdocs-material[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.1-build_backend.patch
)

S="${WORKDIR}"/python-${PV}

distutils_enable_tests pytest
