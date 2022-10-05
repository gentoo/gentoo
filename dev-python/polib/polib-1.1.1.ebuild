# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A library to manipulate gettext files (.po and .mo files)"
HOMEPAGE="https://github.com/izimobil/polib https://polib.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

distutils_enable_sphinx docs

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.7-BE-test.patch
)

python_test() {
	"${EPYTHON}" tests/tests.py -v || die "Tests failed under ${EPYTHON}"
}
