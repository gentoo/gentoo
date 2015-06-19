# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Curses/Curses-1.280.0-r1.ebuild,v 1.1 2014/08/24 02:26:11 axs Exp $

EAPI=5

MODULE_AUTHOR=GIRAFFED
MODULE_VERSION=1.28
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="Curses interface modules for Perl"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~sparc-solaris ~x86-solaris"
IUSE="unicode"

DEPEND=">=sys-libs/ncurses-5[unicode?]"
RDEPEND="${DEPEND}"

SRC_TEST="do"

my_curses_version() {
	echo ncurses$(use unicode && echo w)
}

pkg_setup() {
	myconf="${myconf} FORMS PANELS MENUS"
	mydoc=HISTORY
	export CURSES_LIBTYPE=$(my_curses_version)
	export CURSES_LDFLAGS=$($(my_curses_version)5-config --libs)
	export CURSES_CFLAGS=$( $(my_curses_version)5-config --cflags)
}

src_configure(){
	perl-module_src_configure
	if ! use unicode ; then
		sed -i 's:<form.h>:"/usr/include/form.h":' "${S}"/c-config.h || die
	fi
}
