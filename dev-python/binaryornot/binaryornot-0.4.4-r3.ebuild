# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Ultra-lightweight pure Python package to guess whether a file is binary or text"
HOMEPAGE="
	https://github.com/binaryornot/binaryornot
	https://pypi.org/project/binaryornot/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

PATCHES=(
	# https://github.com/audreyr/binaryornot/commit/38dee57986c6679d9936a1da6f6c8182da3734f8
	"${FILESDIR}"/${P}-tests.patch
)

distutils_enable_tests unittest
distutils_enable_sphinx docs
