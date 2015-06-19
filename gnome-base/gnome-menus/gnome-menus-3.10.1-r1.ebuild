# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-menus/gnome-menus-3.10.1-r1.ebuild,v 1.10 2015/06/07 10:45:55 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Library for the Desktop Menu fd.o specification"
HOMEPAGE="https://git.gnome.org/browse/gnome-menus"
SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~tetromino/distfiles/${PN}/${PN}-3.10.1-patches.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="debug +introspection test"

COMMON_DEPEND="
	>=dev-libs/glib-2.29.15:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
"
# Older versions of slot 0 install the menu editor and the desktop directories

RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gnome-menus-3.0.1-r1:0
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/gjs )
"

src_prepare() {
	# Don't show KDE standalone settings desktop files in GNOME others menu
	epatch "${FILESDIR}/${PN}-3.8.0-ignore_kde_standalone.patch"

	# Fixes for crashes and memory leaks from upstream git master
	epatch ../"${PN}-3.10.1-patches"/*.patch

	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"

	# Do NOT compile with --disable-debug/--enable-debug=no
	# It disables api usage checks
	gnome2_src_configure \
		$(usex debug --enable-debug=yes --enable-debug=minimum) \
		$(use_enable introspection) \
		--disable-static
}
