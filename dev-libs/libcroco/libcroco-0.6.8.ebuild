# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Generic Cascading Style Sheet (CSS) parsing and manipulation toolkit"
HOMEPAGE="https://git.gnome.org/browse/libcroco/"

LICENSE="LGPL-2"
SLOT="0.6"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="dev-libs/glib:2
	>=dev-libs/libxml2-2.4.23"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig"

src_prepare() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README TODO"
	G2CONF+=" --disable-static"
	[[ ${CHOST} == *-darwin* ]] && G2CONF+=" --disable-Bsymbolic"

	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS .*\=.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	gnome2_src_prepare
}
