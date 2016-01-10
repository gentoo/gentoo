# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GIRAFFED
MODULE_VERSION=1.32
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="Curses interface modules for Perl"

SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~sparc-solaris ~x86-solaris"
IUSE="+unicode"

DEPEND=">=sys-libs/ncurses-5:0=[unicode?]"
RDEPEND="${DEPEND}"

SRC_TEST="do"

my_curses_unicode() {
	echo ncurses$(use unicode && echo w)
}

my_curses_version() {
	echo ncurses$(use unicode && echo w)$(has_version '>sys-libs/ncurses-6' && echo 6 || echo 5)
}

pkg_setup() {
	myconf="${myconf} FORMS PANELS MENUS"
	mydoc=HISTORY
	export CURSES_LIBTYPE=$(my_curses_unicode)
	export CURSES_LDFLAGS=$($(my_curses_version)-config --libs)
	export CURSES_CFLAGS=$( $(my_curses_version)-config --cflags)
}

src_configure(){
	perl-module_src_configure
	if ! use unicode ; then
		sed -i 's:<form.h>:"/usr/include/form.h":' "${S}"/c-config.h || die
	fi
}
