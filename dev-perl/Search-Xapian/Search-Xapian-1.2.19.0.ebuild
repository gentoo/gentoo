# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Search-Xapian/Search-Xapian-1.2.19.0.ebuild,v 1.9 2015/06/13 22:42:19 dilfridge Exp $

EAPI="5"

MODULE_AUTHOR=OLLY
inherit perl-module toolchain-funcs versionator

VERSION=$(get_version_component_range 1-3)

SRC_URI+=" http://oligarchy.co.uk/xapian/${VERSION}/${P}.tar.gz"
DESCRIPTION="Perl XS frontend to the Xapian C++ search library"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86"
IUSE="examples"

RDEPEND="~dev-libs/xapian-${VERSION}
	!dev-libs/xapian-bindings[perl]"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"

myconf="CXX=$(tc-getCXX) CXXFLAGS=${CXXFLAGS}"

src_install() {
	perl-module_src_install

	use examples && {
		docinto examples
		dodoc "${S}"/examples/*
	}
}
