# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Ultra-lightweight pure Python package to guess whether a file is binary or text"
HOMEPAGE="https://github.com/audreyfeldroy/binaryornot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz -> ${P}.r1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

RDEPEND=">=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

PATCHES=(
	# https://github.com/audreyr/binaryornot/commit/38dee57986c6679d9936a1da6f6c8182da3734f8
	"${FILESDIR}"/${P}-tests.patch
)

distutils_enable_tests unittest
distutils_enable_sphinx docs
