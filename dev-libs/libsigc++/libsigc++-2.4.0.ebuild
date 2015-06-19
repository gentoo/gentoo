# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsigc++/libsigc++-2.4.0.ebuild,v 1.12 2015/03/05 23:06:14 tetromino Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2 flag-o-matic

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="http://libsigc.sourceforge.net/"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"

RDEPEND=""
DEPEND="sys-devel/m4"
# Needs mm-common for eautoreconf

src_prepare() {
	# don't waste time building examples
	sed -i 's|^\(SUBDIRS =.*\)examples\(.*\)$|\1\2|' \
		Makefile.am Makefile.in || die "sed examples failed"

	# don't waste time building tests unless USE=test
	if ! use test ; then
		sed -i 's|^\(SUBDIRS =.*\)tests\(.*\)$|\1\2|' \
			Makefile.am Makefile.in || die "sed tests failed"
	fi

	gnome2_src_prepare
}

src_configure() {
	filter-flags -fno-exceptions #84263

	gnome2_src_configure \
		$(use_enable doc documentation) \
		$(use_enable static-libs static)
}

src_install() {
	gnome2_src_install

	if use doc ; then
		dohtml -r docs/reference/html/* docs/images/*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
