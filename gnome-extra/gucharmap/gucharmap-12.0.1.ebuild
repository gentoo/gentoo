# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit eapi7-ver gnome2 vala

DESCRIPTION="Unicode character map viewer and library"
HOMEPAGE="https://wiki.gnome.org/Apps/Gucharmap"

LICENSE="GPL-3+"
SLOT="2.90"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"

IUSE="debug +introspection test vala"
REQUIRED_USE="vala? ( introspection )"

UNICODE_VERSION=$(ver_cut 1-2)

COMMON_DEPEND="
	=app-i18n/unicode-data-${UNICODE_VERSION}*
	>=dev-libs/glib-2.32:2
	>=x11-libs/pango-1.2.1[introspection?]
	>=x11-libs/gtk+-3.16:3[introspection?]
	media-libs/freetype:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/gucharmap-3:0
"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.40
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? (	app-text/docbook-xml-dtd:4.1.2 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	# prevent file collisions with slot 0
	sed -e "s:GETTEXT_PACKAGE=gucharmap$:GETTEXT_PACKAGE=gucharmap-${SLOT}:" \
		-i configure.ac configure || die "sed configure.ac configure failed"

	# avoid autoreconf
	sed -e 's/-Wall //g' -i configure || die "sed failed"

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# unihan is not really conditional
	# https://bugzilla.gnome.org/show_bug.cgi?id=768210#c5
	# https://gitlab.gnome.org/GNOME/gucharmap/issues/13
	gnome2_src_configure \
		--disable-static \
		--with-unicode-data=/usr/share/unicode-data \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable introspection) \
		$(use_enable vala)
}
