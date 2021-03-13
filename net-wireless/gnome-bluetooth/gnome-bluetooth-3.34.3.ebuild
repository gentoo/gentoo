# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson udev xdg

DESCRIPTION="Bluetooth graphical utilities integrated with GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeBluetooth"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="2/13" # subslot = libgnome-bluetooth soname version
IUSE="gtk-doc +introspection"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

DEPEND="
	>=dev-libs/glib-2.38:2
	>=x11-libs/gtk+-3.12:3[introspection?]
	media-libs/libcanberra[gtk3]
	>=x11-libs/libnotify-0.7.0
	virtual/libudev
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}
	acct-group/plugdev
	virtual/udev
	>=net-wireless/bluez-5
"
BDEPEND="
	>=dev-util/meson-0.49.0
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.9 )
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dicon_update=false
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	udev_dorules "${FILESDIR}"/61-${PN}.rules
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! has_version 'sys-auth/consolekit[acl]' && ! has_version 'sys-apps/systemd[acl]' ; then
		elog "Don't forget to add yourself to the plugdev group "
		elog "if you want to be able to control bluetooth transmitter."
	fi
}
