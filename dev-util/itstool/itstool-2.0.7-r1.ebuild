# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="xml(+)"

inherit python-single-r1

DESCRIPTION="Translation tool for XML documents that uses gettext files and ITS rules"
HOMEPAGE="http://itstool.org/"
SRC_URI="http://files.itstool.org/itstool/${P}.tar.bz2"

# files in /usr/share/itstool/its are under a special exception || GPL-3+
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/libxml2[python,${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=(ChangeLog NEWS) # AUTHORS, README are empty

PATCHES="
	"${FILESDIR}"/${PN}-2.0.7-missing-translation-fix.patch"

src_test() {
	:
	#"${PYTHON}" tests/run_tests.py || die "test suite failed" # Test suite not shipped in tarball
}
