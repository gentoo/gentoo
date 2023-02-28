# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME_ORG_MODULE="network-manager-applet"

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="NetworkManager connection editor and applet"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
IUSE="appindicator modemmanager selinux teamd"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=app-crypt/libsecret-0.18
	>=net-libs/libnma-1.10.4-r2
	>=x11-libs/gtk+-3.10:3
	>=dev-libs/libgudev-147:=
	>=net-misc/networkmanager-1.16:=[modemmanager?,teamd?]
	appindicator? (
		dev-libs/libayatana-appindicator
		>=dev-libs/libdbusmenu-16.04.0
	)
	modemmanager? ( net-misc/modemmanager )
	selinux? ( sys-libs/libselinux )
	teamd? ( >=dev-libs/jansson-2.7:= )

	virtual/freedesktop-icon-theme
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dappindicator=$(usex appindicator ayatana no)
		$(meson_use modemmanager wwan)
		$(meson_use selinux)
		$(meson_use teamd team)
		-Dmore_asserts=0
		-Dld_gc=false
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
