# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="Desktop integration portal"
HOMEPAGE="https://flatpak.org/ https://github.com/flatpak/xdg-desktop-portal"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="geolocation libportal systemd"

DEPEND="
	>=dev-libs/glib-2.66:2
	dev-libs/json-glib
	>=sys-fs/fuse-3.10.0:3[suid]
	x11-libs/gdk-pixbuf
	>=media-video/pipewire-0.3:=
	geolocation? ( >=app-misc/geoclue-2.5.3:2.0 )
	libportal? ( dev-libs/libportal )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	sys-apps/dbus
"
BDEPEND="
	dev-util/gdbus-codegen
	sys-devel/gettext
"

PATCHES=(
	# These tests require connections to pipewire, internet, /dev/fuse
	"${FILESDIR}/${P}-sandbox-disable-failing-tests.patch"
)

src_configure() {
	local emesonargs=(
		-Ddocbook-docs=disabled # requires flatpak
		-Dsystemd-user-unit-dir="$(systemd_get_userunitdir)"
		$(meson_feature geolocation geoclue)
		$(meson_feature libportal)
		$(meson_feature systemd)
	)
	meson_src_configure
}

pkg_postinst() {
	if ! has_version gui-libs/xdg-desktop-portal-lxqt && ! has_version gui-libs/xdg-desktop-portal-wlr && \
		! has_version kde-plasma/xdg-desktop-portal-kde && ! has_version sys-apps/xdg-desktop-portal-gnome && \
		! has_version sys-apps/xdg-desktop-portal-gtk; then
		elog "${PN} is not usable without any of the following XDP"
		elog "implementations installed:"
		elog "  gui-libs/xdg-desktop-portal-lxqt"
		elog "  gui-libs/xdg-desktop-portal-wlr"
		elog "  kde-plasma/xdg-desktop-portal-kde"
		elog "  sys-apps/xdg-desktop-portal-gnome"
		elog "  sys-apps/xdg-desktop-portal-gtk"
	fi
}
