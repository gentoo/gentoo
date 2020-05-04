# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic meson xdg-utils

DESCRIPTION="Enlightenment window manager"
HOMEPAGE="https://www.enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0.17/${PV%%_*}"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="acpi bluetooth connman doc geolocation nls pam systemd udisks wayland wifi xwayland"

REQUIRED_USE="xwayland? ( wayland )"

RDEPEND="
	>=dev-libs/efl-1.22.3[eet,X]
	virtual/udev
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-misc/xkeyboard-config
	acpi? ( sys-power/acpid )
	bluetooth? ( net-wireless/bluez )
	connman? ( dev-libs/efl[connman] )
	geolocation? ( app-misc/geoclue:2.0 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	udisks? ( sys-fs/udisks:2 )
	wayland? (
		>=dev-libs/efl-1.22.0[drm,wayland]
		dev-libs/wayland
		x11-libs/libxkbcommon
		x11-libs/pixman
	)
	xwayland? (
		dev-libs/efl[X,wayland]
		x11-base/xorg-server[wayland]
	)
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-D device-udev=true
		-D install-enlightenment-menu=true

		-D bluez4=false
		-D install-sysactions=false
		-D mount-eeze=false

		-D packagekit=false

		$(meson_use udisks mount-udisks)
		$(meson_use bluetooth bluez5)
		$(meson_use connman)
		$(meson_use geolocation)
		$(meson_use nls)
		$(meson_use pam)
		$(meson_use systemd)
		$(meson_use wayland wl)
		$(meson_use wifi wireless)
		$(meson_use xwayland)
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
		)
	fi

	append-cflags -fcommon

	meson_src_configure
}

src_install() {
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf

	use doc && local HTML_DOCS=( doc/. )
	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	einfo "Additional programs to complete full EFL suite: "
	optfeature "office file thumbnails" app-office/libreoffice app-office/libreoffice-bin
	optfeature "an EFL-based IDE" dev-util/edi
	optfeature "image viewer" media-gfx/ephoto
	optfeature "ConnMan user interface for Enlightenment" net-misc/econnman
	optfeature "system and process monitor" sys-process/evisum
	optfeature "feature rich terminal emulator" x11-terms/terminology
	optfeature "a modern flat enlightenment WM theme" x11-themes/e-flat-theme
	optfeature "a matching GTK theme" x11-themes/e-gtk-theme
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
