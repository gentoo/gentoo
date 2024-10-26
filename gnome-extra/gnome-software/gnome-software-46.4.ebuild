# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson virtualx xdg

DESCRIPTION="Gnome install & update software"
HOMEPAGE="https://apps.gnome.org/Software"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"
IUSE="flatpak +firmware gnome gtk-doc sysprof udev snap test"

RDEPEND="
	>=dev-libs/appstream-0.14.0:0=
	>=x11-libs/gdk-pixbuf-2.32.0:2
	>=dev-libs/libxmlb-0.1.7:=
	>=gui-libs/gtk-4.12.0:4
	>=dev-libs/glib-2.70.0:2
	>=dev-libs/json-glib-1.6.0
	>=net-libs/libsoup-3.0:3.0
	>=gui-libs/libadwaita-1.4.0:1
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	gnome? ( >=gnome-base/gsettings-desktop-schemas-3.18.0 )
	sys-auth/polkit
	firmware? ( >=sys-apps/fwupd-1.6.2 )
	flatpak? (
		>=sys-apps/flatpak-1.14.0-r1
		dev-util/ostree
	)
	snap? (
		app-containers/snapd
		sys-libs/snapd-glib:=
	)
	udev? ( dev-libs/libgudev )
	>=gnome-base/gsettings-desktop-schemas-3.11.5
"
DEPEND="${RDEPEND}
	test? ( dev-libs/libglib-testing )
"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
"

src_prepare() {
	default
	xdg_environment_reset

	sed -i -e '/install_data.*README\.md.*share\/doc\/gnome-software/d' meson.build || die
	# We don't need language packs download support, and it fails tests in 3.34.2 for us (if they are enabled)
	sed -i -e '/subdir.*fedora-langpacks/d' plugins/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		$(meson_feature gnome gsettings_desktop_schemas) # Honoring of GNOME date format settings.
		-Dman=true
		-Dpackagekit=false
		# -Dpackagekit_autoremove
		-Dpolkit=true
		-Deos_updater=false # Endless OS updater
		$(meson_use firmware fwupd)
		$(meson_use flatpak)
		-Dmalcontent=false
		-Drpm_ostree=false
		-Dwebapps=true
		-Dhardcoded_foss_webapps=true
		-Dhardcoded_proprietary_webapps=true
		$(meson_use udev gudev)
		-Dapt=false
		$(meson_use snap)
		-Dexternal_appstream=false
		$(meson_use gtk-doc gtk_doc)
		-Dhardcoded_curated=true
		# TODO: Will this be beneficial to us with flatpak at least? If
		# enabled, it shows some apps under installed (probably merely due to
		# /usr/share/app-info presence), but launching and removal of them is
		# broken
		-Ddefault_featured_apps=false
		-Dmogwai=false #TODO?
		$(meson_feature sysprof)
		-Dprofile=''
		-Dsoup2=false
		-Dopensuse-distro-upgrade=false
	)
	meson_src_configure
}

src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
