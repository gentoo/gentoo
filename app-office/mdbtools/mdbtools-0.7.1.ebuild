# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/mdbtools/mdbtools-0.7.1.ebuild,v 1.9 2015/06/07 08:11:23 jlec Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1 # needed for proper man generation
inherit autotools-utils

DESCRIPTION="A set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="http://mdbtools.sourceforge.net"
SRC_URI="https://github.com/brianb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

IUSE="gnome odbc static-libs"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses
	sys-libs/readline:0
	gnome? (
		gnome-base/libglade:2.0
		gnome-base/libgnomeui
	)
	odbc? ( >=dev-db/unixODBC-2.0 )"
DEPEND="${RDEPEND}
	app-text/txt2man
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc"

DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO )

PATCHES=( "${FILESDIR}/${P}-parallel-make.patch" )

src_configure() {
	local myeconfargs=(
		--disable-gtk-doc
		$(use_enable gnome gmdb2)
		$(use odbc && echo "--with-unixodbc=${EPREFIX}/usr")
	)
	autotools-utils_src_configure
}
