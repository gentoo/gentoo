# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

inherit gnome.org gnome2-utils python-any-r1 meson udev virtualx xdg

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-settings-daemon"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+colord +cups debug elogind input_devices_wacom modemmanager networkmanager smartcard systemd test +udev wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	^^ ( elogind systemd )
	input_devices_wacom? ( udev )
	wayland? ( udev )
"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

DEPEND="
	>=sci-geosciences/geocode-glib-3.10
	>=dev-libs/glib-2.56:2
	>=gnome-base/gnome-desktop-3.34.2:3=
	>=gnome-base/gsettings-desktop-schemas-3.35.91
	>=x11-libs/gtk+-3.15.3:3[X,wayland?]
	>=dev-libs/libgweather-3.9.5:2=
	colord? (
		>=x11-misc/colord-1.3.5:=
		>=media-libs/lcms-2.2:2 )
	media-libs/libcanberra[gtk3]
	>=app-misc/geoclue-2.3.1:2.0
	>=x11-libs/libnotify-0.7.3
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.114
	>=sys-power/upower-0.99.8:=
	x11-libs/libX11
	udev? ( dev-libs/libgudev:= )
	wayland? ( dev-libs/wayland )
	input_devices_wacom? ( >=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20.0
		x11-libs/gdk-pixbuf:2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	cups? ( >=net-print/cups-1.4[dbus] )
	modemmanager? ( >=app-crypt/gcr-3.7.5:=
		>=net-misc/modemmanager-1.0:= )
	networkmanager? ( >=net-misc/networkmanager-1.0 )
	media-libs/alsa-lib
	x11-libs/libXi
	x11-libs/libXext
	media-libs/fontconfig
	systemd? ( >=sys-apps/systemd-243
		sys-apps/dbus[user-session] )
"
# logind needed for power and session management, bug #464944
# gnome-session-3.33.90/gdm-3.33.90/gnome-shell-extensions-3.34.1/gnome-flashback-3.33.1 adapt to Clipboard and Mouse component removals (moved to mutter)
RDEPEND="${DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
	!<gnome-base/gnome-session-3.33.90
	!<gnome-base/gdm-3.33.90
	!<gnome-extra/gnome-shell-extensions-3.34.1
	!<gnome-base/gnome-flashback-3.33.1
"
# rfkill requires linux/rfkill.h (and USE=udev), thus linux-headers dep, not os-headers. If this package wants to work on other kernels, we need to make rfkill conditional instead
BDEPEND="
	sys-kernel/linux-headers
	dev-util/glib-utils
	dev-util/gdbus-codegen
	x11-base/xorg-proto
	${PYTHON_DEPS}
	test? (
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-build-Make-colord-and-wacom-optional-and-controllabl.patch
	"${FILESDIR}"/${P}-build-Allow-NM-optional-on-Linux.patch
	"${FILESDIR}"/${P}-Allow-udev-optional-on-Linux.patch
)

python_check_deps() {
	if use test; then
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		#-Dnssdb_dir # TODO: Is the default /etc/pki/nssdb path correct for our nss?
		-Dudev_dir="$(get_udevdir)"
		$(meson_use systemd)
		-Dalsa=true
		$(meson_use udev gudev)
		$(meson_use colord)
		$(meson_use cups)
		$(meson_use networkmanager network_manager)
		$(meson_use udev rfkill)
		$(meson_use smartcard)
		$(meson_use input_devices_wacom wacom)
		$(meson_use wayland)
		$(meson_use modemmanager wwan)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	# Don't auto-suspend by default on AC power
	insinto /usr/share/glib-2.0/schemas
	doins "${FILESDIR}"/org.gnome.settings-daemon.plugins.power.gschema.override
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
