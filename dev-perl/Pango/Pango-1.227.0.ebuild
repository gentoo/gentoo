# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=XAOC
DIST_VERSION=1.227
VIRTUALX_REQUIRED=manual

inherit perl-module virtualx

DESCRIPTION="Layout and render international text"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples test minimal"

RDEPEND="
	>=dev-perl/glib-perl-1.220.0
	>=dev-perl/Cairo-1.0.0
	>=x11-libs/pango-1.0.0
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/extutils-pkgconfig-1.30.0
	test? (
		virtual/perl-Test-Simple
		!minimal? (
			>=dev-perl/gtk2-perl-1.220.0
			$VIRTUALX_DEPEND
		)
	)
"

src_prepare() {
	perl-module_src_prepare
	sed -i -e "s:exit 0:exit 1:g" "${S}"/Makefile.PL || die "sed failed"
}
src_install() {
	local mydoc
	mydoc=("NEWS")
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
src_test() {
	virtx perl-module_src_test
}
