# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature xdg

DESCRIPTION="Enlightenment window manager"
HOMEPAGE="https://www.enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="BSD-2"

# Historically enlightenment was slotted to separate e16 from e17. e16 is now
# packaged as x11-wm/e16, but the slot is kept because it's more complicated to
# reset it rather than just to keep it.
SLOT="0.17/${PV%%_*}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="acpi bluetooth connman doc exif geolocation nls pam policykit systemd udisks wayland xwayland"

REQUIRED_USE="xwayland? ( wayland )"

RDEPEND=">=dev-libs/efl-1.26.1[eet,fontconfig,X]
	virtual/udev
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-misc/xkeyboard-config
	acpi? ( sys-power/acpid )
	bluetooth? ( net-wireless/bluez )
	connman? ( dev-libs/efl[connman] )
	exif? ( media-libs/libexif )
	geolocation? ( app-misc/geoclue:2.0 )
	pam? ( sys-libs/pam )
	policykit? ( sys-auth/polkit )
	systemd? ( sys-apps/systemd )
	udisks? ( sys-fs/udisks:2 )
	wayland? (
		|| (
			dev-libs/efl[systemd]
			dev-libs/efl[elogind]
		)
		dev-libs/efl[drm,wayland]
		dev-libs/wayland
		x11-libs/libxkbcommon
		x11-libs/pixman
	)
	xwayland? (
		dev-libs/efl[X,wayland]
		x11-base/xwayland
	)"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-D device-udev=true
		-D elput=true
		-D install-enlightenment-menu=true

		-D install-sysactions=true
		-D install-system=true
		-D mount-eeze=false

		-D packagekit=false

		$(meson_use udisks mount-udisks)
		$(meson_use bluetooth bluez5)
		$(meson_use connman)
		$(meson_use exif libexif)
		$(meson_use geolocation)
		$(meson_use nls)
		$(meson_use pam)
		$(meson_use policykit polkit)
		$(meson_use systemd)
		$(meson_use wayland wl)
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

	meson_src_configure
}

src_install() {
	use doc && local HTML_DOCS=( doc/. )
	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update

	optfeature_header "Additional programs to complement the full EFL suite:"
	optfeature "efl-based pinentry interface" app-crypt/pinentry[efl]
	optfeature "an efl-based text editor" app-editors/ecrire
	optfeature "better monitor backlight and brightness controls" app-misc/ddcutil
	optfeature "office file thumbnails" app-office/libreoffice app-office/libreoffice-bin
	optfeature "an EFL-based IDE" dev-util/edi
	optfeature "image viewer" media-gfx/entice
	optfeature "image viewer" media-gfx/ephoto
	optfeature "a media player" media-video/rage
	optfeature "ConnMan user interface for Enlightenment" net-misc/econnman
	optfeature "system and process monitor" sys-process/evisum
	optfeature "feature rich terminal emulator" x11-terms/terminology
	optfeature "a matching GTK theme" x11-themes/e-gtk-theme
}
