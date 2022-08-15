# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson xdg

DESCRIPTION="Library with common API for various GNOME modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-desktop/"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1+"
SLOT="3/19" # subslot = libgnome-desktop-3 soname version
IUSE="debug +introspection seccomp systemd udev"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.36.5:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[introspection?]
	>=dev-libs/glib-2.53.0:2
	>=gnome-base/gsettings-desktop-schemas-3.27.0[introspection?]
	x11-misc/xkeyboard-config
	x11-libs/libxkbcommon
	app-text/iso-codes
	systemd? ( sys-apps/systemd:= )
	udev? ( virtual/libudev:= )
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
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/42.0-meson-Add-optionality-for-introspection.patch
)

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
		-Ddesktop_docs=false
		$(meson_use debug debug_tools)
		$(meson_use introspection)
		$(meson_feature udev)
		$(meson_feature systemd)
		-Dgtk_doc=false
		-Dinstalled_tests=false
		-Dbuild_gtk4=false
		-Dlegacy_library=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	rm -r \
		"${ED}"/usr/share/gnome/gnome-version.xml \
		"${ED}"/usr/share/locale \
		|| die
}
