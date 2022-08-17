# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Python bindings for wc(s)width"
HOMEPAGE="
	https://github.com/sebastinas/cwcwidth/
	https://pypi.org/project/cwcwidth/"
SRC_URI="
	https://github.com/sebastinas/cwcwidth/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_test() {
	cd tests || die
	distutils-r1_src_test
}
