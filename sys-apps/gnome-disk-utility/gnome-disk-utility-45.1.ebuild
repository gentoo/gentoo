# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Disk Utility for GNOME using udisks"
HOMEPAGE="https://wiki.gnome.org/Apps/Disks"

LICENSE="GPL-2+"
SLOT="0"
IUSE="fat elogind gnome systemd"
REQUIRED_USE="?? ( elogind systemd )"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"

DEPEND="
	>=media-libs/libdvdread-4.2.0:0=
	>=dev-libs/glib-2.31:2
	>=x11-libs/gtk+-3.16.0:3
	>=media-libs/libcanberra-0.1[gtk3]
	>=gui-libs/libhandy-1.5.0:1
	>=app-arch/xz-utils-5.0.5
	>=x11-libs/libnotify-0.7
	>=app-crypt/libsecret-0.7
	>=dev-libs/libpwquality-1.0.0
	>=sys-fs/udisks-2.7.6:2
	elogind? ( >=sys-auth/elogind-209 )
	systemd? ( >=sys-apps/systemd-209:0= )
"
RDEPEND="${DEPEND}
	x11-themes/adwaita-icon-theme
	fat? ( sys-fs/dosfstools )
	gnome? ( >=gnome-base/gnome-settings-daemon-3.8 )
"
# libxml2 for xml-stripblanks in gresource
BDEPEND="
	dev-libs/libxml2:2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dlogind=$(usex systemd libsystemd $(usex elogind libelogind none))
		$(meson_use gnome gsd_plugin)
		-Dman=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
