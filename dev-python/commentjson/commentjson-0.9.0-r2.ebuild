# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Add Python and JavaScript style comments in your JSON files"
HOMEPAGE="
	https://pypi.org/project/commentjson/
	https://github.com/vaidik/commentjson/
"
SRC_URI="
	https://github.com/vaidik/commentjson/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/lark[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	local PATCHES=(
		# https://github.com/vaidik/commentjson/pull/54
		"${FILESDIR}/${P}-py312.patch"
	)

	distutils-r1_src_prepare

	# remove lark-parser dependency to allow painless upgrade to lark
	sed -e '/lark-parser/d' -i setup.py || die
}
