# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GIRAFFED
DIST_VERSION=1.44
DIST_EXAMPLES=("demo" "demo2" "demo.form" "demo.menu" "demo.panel")
inherit perl-module toolchain-funcs

DESCRIPTION="Curses interface modules for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~ppc ppc64 ~s390 ~sparc x86"
IUSE="+unicode"

RDEPEND="
	>=sys-libs/ncurses-6:=[unicode(+)?]
	virtual/perl-Data-Dumper
"
DEPEND="
	>=sys-libs/ncurses-6:=[unicode(+)?]
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
	test? ( virtual/perl-Test-Simple )
"

src_configure() {
	myconf=( FORMS PANELS MENUS )
	mydoc=( HISTORY )

	export CURSES_LIBTYPE="$(usex unicode ncursesw ncurses)"
	export CURSES_LDFLAGS=$($(tc-getPKG_CONFIG) --libs ${CURSES_LIBTYPE} || die)
	export CURSES_CFLAGS=$($(tc-getPKG_CONFIG) --cflags ${CURSES_LIBTYPE} || die)

	perl-module_src_configure

	if ! use unicode ; then
		sed -i "s:<form.h>:\"${ESYSROOT}/usr/include/form.h\":" "${S}"/c-config.h || die
	fi
}
