# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="Stream the desktop to Wi-Fi Display capable devices"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-network-displays"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="firewalld test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	gnome-base/gnome-desktop:3
	media-libs/gst-rtsp-server
	media-libs/libpulse[glib]
	media-plugins/gst-plugins-faac
	media-plugins/gst-plugins-x264
	media-plugins/gst-plugins-ximagesrc
	>=gui-libs/gtk-4
	>=net-misc/networkmanager-1.16.0[wifi]
	>=dev-libs/libportal-0.7[gtk]
	>=gui-libs/libadwaita-1
	net-dns/dnsmasq
	net-wireless/wpa_supplicant[p2p]
	sys-apps/xdg-desktop-portal[screencast(+)]
	firewalld? ( net-firewall/firewalld )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/gettext
	virtual/pkgconfig
	dev-libs/protobuf-c
	test? (
		dev-libs/appstream-glib
		dev-util/desktop-file-utils
	)
"

DOCS=( README.md )

src_prepare() {
	default
	# https://gitlab.gnome.org/GNOME/gnome-network-displays/-/issues/272
	sed -i -e "s/args: \['validate'/args: \['--nonet', 'validate'/" \
		data/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use firewalld firewalld_zone)
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
