# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala virtualx

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://live.gnome.org/Gucharmap"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="${COMMON_DEPEND}
	>=dev-libs/gjs-1.43.3
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.35.9
	>=dev-libs/libunistring-0.9.5
	>=x11-libs/gtk+-3:3[introspection]
	>=x11-libs/pango-1.36[introspection]
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-util/dogtail )
"

src_configure() {
	gnome2_src_configure $(use_enable test dogtail)
}

src_test() {
	Xemake check
}
