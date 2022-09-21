# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson xdg

DESCRIPTION="Library with common API for various GNOME modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-desktop/"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1+"
SLOT="4/1" # subslot = libgnome-desktop-4 soname version
IUSE="debug gtk-doc seccomp systemd udev"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.36.5:2[introspection]
	>=gui-libs/gtk-4.4.0:4[introspection]
	>=dev-libs/glib-2.53.0:2
	>=gnome-base/gsettings-desktop-schemas-3.27.0[introspection]
	x11-misc/xkeyboard-config
	x11-libs/libxkbcommon
	app-text/iso-codes
	systemd? ( sys-apps/systemd:= )
	udev? ( virtual/libudev:= )
	seccomp? ( sys-libs/libseccomp )

	x11-libs/cairo:=
	>=dev-libs/gobject-introspection-1.54:=
"
DEPEND="${COMMON_DEPEND}
	media-libs/fontconfig
"
RDEPEND="${COMMON_DEPEND}
	seccomp? ( sys-apps/bubblewrap )
	!<gnome-base/gnome-desktop-${PV}:3
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	gtk-doc? ( >=dev-util/gtk-doc-1.14 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	xdg_environment_reset

	# Don't build manual test programs that will never get run
	sed -i -e "/'test-.*'/d" libgnome-desktop/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dgnome_distributor=Gentoo
		-Ddate_in_gnome_version=true
		-Ddesktop_docs=true
		$(meson_use debug debug_tools)
		$(meson_feature udev)
		$(meson_feature systemd)
		$(meson_use gtk-doc gtk_doc)
		-Dinstalled_tests=false
		-Dbuild_gtk4=true
		-Dlegacy_library=false
	)
	meson_src_configure
}
