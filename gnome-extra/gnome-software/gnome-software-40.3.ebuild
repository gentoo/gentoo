# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Gnome install & update software"
HOMEPAGE="https://wiki.gnome.org/Apps/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flatpak +firmware gnome gtk-doc packagekit spell sysprof udev"
RESTRICT="test" # writes to and deletes files in /var/tmp/self-test/

RDEPEND="
	>=dev-libs/appstream-0.14.0:0=
	>=x11-libs/gdk-pixbuf-2.32.0:2
	>=dev-libs/libxmlb-0.1.7:=
	net-libs/gnome-online-accounts:=
	>=x11-libs/gtk+-3.22.4:3
	>=dev-libs/glib-2.56:2
	>=dev-libs/json-glib-1.2.0
	>=net-libs/libsoup-2.52.0:2.4
	>=gui-libs/libhandy-1.0.2:1=
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	gnome? ( >=gnome-base/gsettings-desktop-schemas-3.18.0 )
	spell? ( app-text/gspell:= )
	sys-auth/polkit
	packagekit? ( >=app-admin/packagekit-base-1.1.0 )
	firmware? ( >=sys-apps/fwupd-1.0.3 )
	flatpak? (
		>=sys-apps/flatpak-1.0.4
		dev-util/ostree
	)
	udev? ( dev-libs/libgudev )
	>=gnome-base/gsettings-desktop-schemas-3.11.5
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
"
# test? ( dev-util/valgrind )

src_prepare() {
	xdg_src_prepare
	sed -i -e '/install_data.*README\.md.*share\/doc\/gnome-software/d' meson.build || die
	# We don't need language packs download support, and it fails tests in 3.34.2 for us (if they are enabled)
	sed -i -e '/subdir.*fedora-langpacks/d' plugins/meson.build || die
	# Trouble talking to spawned gnome-keyring socket for some reason, even if wrapped in dbus-run-session
	# TODO: Investigate; seems to work outside ebuild .. test/emerge
	sed -i -e '/g_test_add_func.*gs_auth_secret_func/d' lib/gs-self-test.c || die
}

src_configure() {
	local emesonargs=(
		-Dtests=false #$(meson_use test tests)
		$(meson_use spell gspell)
		$(meson_feature gnome gsettings_desktop_schemas) # Honoring of GNOME date format settings.
		-Dman=true
		$(meson_use packagekit)
		# -Dpackagekit_autoremove
		-Dpolkit=true
		-Deos_updater=false # Endless OS updater
		$(meson_use firmware fwupd)
		$(meson_use flatpak)
		-Dmalcontent=false
		-Drpm_ostree=false
		-Dodrs=false
		$(meson_use udev gudev)
		-Dapt=false
		-Dsnap=false
		-Dexternal_appstream=false
		-Dvalgrind=false
		$(meson_use gtk-doc gtk_doc)
		-Dhardcoded_popular=true
		-Ddefault_featured_apps=false # TODO: Will this be beneficial to us with flatpak at least? If enabled, it shows some apps under installed (probably merely due to /usr/share/app-info presence), but launching and removal of them is broken
		-Dmogwai=false #TODO?
		$(meson_feature sysprof)
	)
	meson_src_configure
}

#src_test() {
#	virtx meson_src_test
#}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
