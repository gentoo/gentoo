# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Library with common API for various GNOME modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-desktop/"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1+"
SLOT="3/19" # subslot = libgnome-desktop-3 soname version
IUSE="debug gtk-doc +introspection seccomp systemd udev"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.36.5:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[X,introspection?]
	>=dev-libs/glib-2.53.0:2
	>=gnome-base/gsettings-desktop-schemas-3.27.0[introspection?]
	x11-misc/xkeyboard-config
	app-text/iso-codes
	systemd? ( sys-apps/systemd:= )
	udev? (
		sys-apps/hwids
		virtual/libudev:= )
	seccomp? ( sys-libs/libseccomp )

	x11-libs/cairo:=
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${COMMON_DEPEND}
	media-libs/fontconfig
"
RDEPEND="${COMMON_DEPEND}
	seccomp? ( sys-apps/bubblewrap )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	gtk-doc? ( >=dev-util/gtk-doc-1.14 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	x11-base/xorg-proto
	virtual/pkgconfig
"
# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xorg-proto

PATCHES=(
	"${FILESDIR}"/3.32.2-optional-introspection.patch # add introspection meson option
)

src_prepare() {
	# Don't build manual test programs that will never get run
	sed -i -e "/'test-.*'/d" libgnome-desktop/meson.build || die
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dgnome_distributor=Gentoo
		-Ddate_in_gnome_version=true
		-Ddesktop_docs=true
		$(meson_use debug debug_tools)
		$(meson_use introspection)
		$(meson_feature udev)
		$(meson_feature systemd)
		$(meson_use gtk-doc gtk_doc)
		-Dinstalled_tests=false
	)
	meson_src_configure
}
