# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Automated testing for the examples in your documentation"
HOMEPAGE="https://github.com/cjw296/sybil"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-py310.patch
)
