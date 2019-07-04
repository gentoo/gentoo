# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate virtualx

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Caja file manager for the MATE desktop"
LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"

IUSE="+introspection +mate packagekit xmp"

RDEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=dev-libs/libxml2-2.4.7:2
	gnome-base/dconf
	>=gnome-base/gvfs-1.10.1:0[udisks]
	>=mate-base/mate-desktop-1.17.3:0
	>=media-libs/libexif-0.6.14:0
	virtual/libintl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=x11-libs/libnotify-0.7.0:0
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrender
	>=x11-libs/pango-1.1.2
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	packagekit? ( app-admin/packagekit-base )
	xmp? ( >=media-libs/exempi-1.99.5:2 )
	!!mate-base/mate-file-manager"

DEPEND="${RDEPEND}
	>=dev-lang/perl-5:=
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40.1
	sys-devel/gettext
	virtual/pkgconfig"

PDEPEND="mate? ( >=x11-themes/mate-icon-theme-${MATE_BRANCH} )"

# TODO: Test fails because Caja is not merged yet:
# GLib-GIO-ERROR **: Settings schema 'org.mate.caja.preferences' is not installed
RESTRICT="test"

src_prepare() {
	# Remove unnecessary CFLAGS.
	sed -i -e 's:-DG.*DISABLE_DEPRECATED::g' \
		configure.ac eel/Makefile.am || die

	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--disable-update-mimedb \
		$(use_enable introspection) \
		$(use_enable packagekit) \
		$(use_enable xmp)
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS

	Xemake check || die "Test phase failed"
}

pkg_postinst() {
	mate_pkg_postinst

	elog "Caja can use gstreamer to preview audio files. Just make sure"
	elog "to have the necessary plugins available to play the media type you"
	elog "want to preview."
}
