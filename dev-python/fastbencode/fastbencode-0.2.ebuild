# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Implementation of bencode with optional fast C extensions"
HOMEPAGE="
	https://github.com/breezy-team/fastbencode/
	https://pypi.org/project/fastbencode/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

PATCHES=(
	# https://github.com/breezy-team/fastbencode/commit/23e8cadcc81c6649d96742f235a98bd3047e5d8a
	"${FILESDIR}"/${P}-py312.patch
)

python_test() {
	cd fastbencode/tests || die
	eunittest
}
