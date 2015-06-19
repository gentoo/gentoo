# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cairo/Cairo-1.105.0.ebuild,v 1.2 2015/05/01 11:53:47 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=XAOC
MODULE_VERSION=1.105
inherit perl-module

DESCRIPTION="Perl interface to the cairo library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="test"

RDEPEND="
	>=x11-libs/cairo-1.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.200.0
	>=dev-perl/extutils-pkgconfig-1.0.0
	test? (
		dev-perl/Test-Number-Delta
	)
"

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
	sed -i -e 's,exit 0,exit 1,' "${S}"/Makefile.PL || die
}
