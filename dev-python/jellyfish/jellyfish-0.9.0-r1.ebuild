# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python module for doing approximate and phonetic matching of strings"
HOMEPAGE="https://github.com/jamesturk/jellyfish https://pypi.org/project/jellyfish/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

distutils_enable_tests pytest

src_test() {
	rm -r jellyfish || die
	distutils-r1_src_test
}

python_test() {
	epytest --pyargs jellyfish.test
}
