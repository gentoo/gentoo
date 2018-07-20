# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OLLY
inherit perl-module toolchain-funcs versionator

VERSION=$(get_version_component_range 1-3)

SRC_URI+=" http://oligarchy.co.uk/xapian/${VERSION}/${P}.tar.gz"
DESCRIPTION="Perl XS frontend to the Xapian C++ search library"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples test"

RDEPEND="dev-libs/xapian:0/1.2.22
	!dev-libs/xapian-bindings[perl]"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Devel-Leak )
"

DIST_TEST=do
# parallel fails sometimes...

myconf="CXX=$(tc-getCXX) CXXFLAGS=${CXXFLAGS}"

src_install() {
	perl-module_src_install

	use examples && {
		docinto examples
		dodoc "${S}"/examples/*
	}
}
