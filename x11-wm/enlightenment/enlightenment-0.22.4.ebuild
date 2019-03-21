# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

DESCRIPTION="Enlightenment window manager"
HOMEPAGE="https://www.enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0.17/${PV%%_*}"
KEYWORDS="amd64 ~ppc x86"
IUSE="acpi bluetooth connman doc geolocation nls packagekit pam systemd udisks wayland wifi"

RDEPEND="
	>=dev-libs/efl-1.20.5[eet,X]
	virtual/udev
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-misc/xkeyboard-config
	acpi? ( sys-power/acpid )
	bluetooth? ( net-wireless/bluez )
	connman? ( dev-libs/efl[connman] )
	geolocation? ( app-misc/geoclue:2.0 )
	packagekit? ( app-admin/packagekit-base )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	udisks? ( sys-fs/udisks:2 )
	wayland? (
		>=dev-libs/efl-1.21.0[drm,wayland]
		dev-libs/wayland
		x11-libs/libxkbcommon
		x11-libs/pixman
	)
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-D device-udev=true
		-D install-sysactions=false
		-D mount-udisks=$(usex udisks true false)
		-D bluez4=$(usex bluetooth true false)
		-D connman=$(usex connman true false)
		-D geolocation=$(usex geolocation true false)
		-D nls=$(usex nls true false)
		-D packagekit=$(usex packagekit true false)
		-D pam=$(usex pam true false)
		-D systemd=$(usex systemd true false)
		-D wayland=$(usex wayland true false)
		-D wireless=$(usex wifi true false)
	)

	if ! use wayland; then
		emesonargs+=(
			-D wl-buffer=false
			-D wl-desktop-shell=false
			-D wl-drm=false
			-D wl-text-input=false
			-D wl-weekeyboard=false
			-D wl-wl=false
			-D wl-x11=false
			-D xwayland=false
		)
	fi

	meson_src_configure
}

src_install() {
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf

	if use doc; then
		local HTML_DOCS=( doc/. )
	fi

	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
