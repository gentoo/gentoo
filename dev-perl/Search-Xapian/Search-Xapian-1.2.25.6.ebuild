# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# parallel fails sometimes...
DIST_TEST=do
DIST_AUTHOR=OLLY
inherit perl-module toolchain-funcs

DESCRIPTION="Perl XS frontend to the Xapian C++ search library"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/xapian-1.4:=[inmemory(+)]
	<dev-libs/xapian-2
	!dev-libs/xapian-bindings[perl]
"
DEPEND="
	${RDEPEND}
	test? ( dev-perl/Devel-Leak )
"

src_configure() {
	myconf="CXX=$(tc-getCXX) CXXFLAGS=${CXXFLAGS} CC=$(tc-getCXX)"
	perl-module_src_configure
}

src_install() {
	perl-module_src_install

	use examples && {
		docinto examples
		dodoc "${S}"/examples/*
	}
}
