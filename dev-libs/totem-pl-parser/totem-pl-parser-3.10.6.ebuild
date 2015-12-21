# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Playlist parsing library"
HOMEPAGE="https://developer.gnome.org/totem-pl-parser/stable/"

LICENSE="LGPL-2+"
SLOT="0/18"
IUSE="archive crypt +introspection +quvi test"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="
	>=dev-libs/glib-2.31:2
	dev-libs/gmime:2.6
	>=net-libs/libsoup-2.43:2.4
	archive? ( >=app-arch/libarchive-3 )
	crypt? ( dev-libs/libgcrypt:0= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	quvi? ( >=media-libs/libquvi-0.9.1:0= )
"
DEPEND="${RDEPEND}
	!<media-video/totem-2.21
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.14
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		gnome-base/gvfs[http]
		sys-apps/dbus )
"
# eautoreconf needs:
#	dev-libs/gobject-introspection-common
#	>=gnome-base/gnome-common-3.6

src_prepare() {
	# Disable tests requiring network access, bug #346127
	# 3rd test fails on upgrade, not once installed
	sed -e 's:\(g_test_add_func.*/parser/resolution.*\):/*\1*/:' \
		-e 's:\(g_test_add_func.*/parser/parsing/itms_link.*\):/*\1*/:' \
		-e 's:\(g_test_add_func.*/parser/parsability.*\):/*\1/:'\
		-i plparse/tests/parser.c || die "sed failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable archive libarchive) \
		$(use_enable crypt libgcrypt) \
		$(use_enable quvi) \
		$(use_enable introspection)
}

src_test() {
	# This is required as told by upstream in bgo#629542
	GVFS_DISABLE_FUSE=1 dbus-run-session emake check || die "emake check failed"
}
