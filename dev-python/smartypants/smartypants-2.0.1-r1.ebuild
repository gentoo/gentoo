# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P="${PN}.py-${PV}"
DESCRIPTION="ASCII quote-dot-dash to HTML entity converter"
HOMEPAGE="
	https://pypi.org/project/smartypants/
	https://github.com/leohemsted/smartypants.py/
"
SRC_URI="
	https://github.com/leohemsted/smartypants.py/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86"

distutils_enable_sphinx docs
distutils_enable_tests unittest

src_prepare() {
	local PATCHES=(
		# https://github.com/leohemsted/smartypants.py/pull/21
		"${FILESDIR}/${P}-py312.patch"
	)

	# relevant only to upstream packaging, requires docutils
	rm tests/test_setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	eunittest -s tests
}
