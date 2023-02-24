# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A library to manipulate gettext files (.po and .mo files)"
HOMEPAGE="
	https://github.com/izimobil/polib/
	https://pypi.org/project/polib/
	https://polib.readthedocs.io/en/latest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

distutils_enable_sphinx docs

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.7-BE-test.patch
)

python_test() {
	"${EPYTHON}" tests/tests.py -v || die "Tests failed under ${EPYTHON}"
}
