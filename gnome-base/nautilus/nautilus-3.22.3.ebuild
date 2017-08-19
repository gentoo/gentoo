# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes" # Needed with USE 'sendto'

inherit gnome2 readme.gentoo-r1 virtualx

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
IUSE="exif gnome +introspection packagekit +previewer selinux sendto tracker xmp"

KEYWORDS="~alpha amd64 ~arm64 ~ia64 x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
# need org.gnome.SessionManager service (aka gnome-session) but cannot find it
RESTRICT="test"

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=app-arch/gnome-autoar-0.1
	>=dev-libs/glib-2.49.1:2[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.21.6:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	gnome-base/dconf
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	exif? ( >=media-libs/libexif-0.6.20 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	selinux? ( >=sys-libs/libselinux-2 )
	tracker? ( >=app-misc/tracker-0.16:= )
	xmp? ( >=media-libs/exempi-2.1.0:2 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.33
	>=dev-util/gtk-doc-am-1.10
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-proto/xproto
"
RDEPEND="${COMMON_DEPEND}
	packagekit? ( app-admin/packagekit-base )
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"

# For eautoreconf
#	gnome-base/gnome-common
#	dev-util/gtk-doc-am"

PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	tracker? ( >=gnome-extra/nautilus-tracker-tags-0.12 )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk]
"
# Need gvfs[gtk] for recent:/// support

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-desktop \
		--disable-profiling \
		--disable-update-mimedb \
		$(use_enable exif libexif) \
		$(use_enable introspection) \
		$(use_enable packagekit) \
		$(use_enable sendto nst-extension) \
		$(use_enable selinux) \
		$(use_enable tracker) \
		$(use_enable xmp)
}

src_test() {
	virtx emake check
}

src_install() {
	use previewer && readme.gentoo_create_doc
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}
