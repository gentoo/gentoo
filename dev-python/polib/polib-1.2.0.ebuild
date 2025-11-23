# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A library to manipulate gettext files (.po and .mo files)"
HOMEPAGE="
	https://github.com/izimobil/polib/
	https://pypi.org/project/polib/
	https://polib.readthedocs.io/en/latest/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		sys-devel/gettext
	)
"

distutils_enable_sphinx docs

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.7-BE-test.patch
	# https://github.com/izimobil/polib/pull/168
	"${FILESDIR}/${P}-gettext-0.22.patch"
)

python_test() {
	"${EPYTHON}" tests/tests.py -v || die "Tests failed under ${EPYTHON}"
}
