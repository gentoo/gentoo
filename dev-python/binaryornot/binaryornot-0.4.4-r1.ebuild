# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Ultra-lightweight pure Python package to guess whether a file is binary or text"
HOMEPAGE="https://github.com/audreyr/binaryornot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

PATCHES=(
	# https://github.com/audreyr/binaryornot/commit/38dee57986c6679d9936a1da6f6c8182da3734f8
	"${FILESDIR}"/${P}-tests.patch
	# Version number has not been updated to 0.4.4
	"${FILESDIR}"/${P}-fix-version-number.patch
)

distutils_enable_tests unittest
distutils_enable_sphinx docs
