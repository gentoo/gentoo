# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit gnome.org gnome2-utils python-any-r1 meson udev virtualx xdg

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-settings-daemon"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+colord +cups debug elogind input_devices_wacom modemmanager networkmanager smartcard systemd test wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( elogind systemd )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=sci-geosciences/geocode-glib-3.10:2
	>=dev-libs/glib-2.58:2
	>=gnome-base/gnome-desktop-3.37.1:3=
	>=gnome-base/gsettings-desktop-schemas-42
	>=x11-libs/gtk+-3.15.3:3[X,wayland?]
	>=dev-libs/libgweather-4.2.0:4=
	colord? ( >=x11-misc/colord-1.4.5:= )
	media-libs/libcanberra[gtk3]
	>=app-misc/geoclue-2.3.1:2.0
	>=x11-libs/libnotify-0.7.3
	>=media-libs/libpulse-16.1[glib]
	>=sys-auth/polkit-0.114
	>=sys-power/upower-0.99.12:=
	x11-libs/libX11
	>=x11-libs/libXfixes-6.0.0
	dev-libs/libgudev:=
	wayland? ( dev-libs/wayland )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7:=
		>=x11-libs/pango-1.20.0
		x11-libs/gdk-pixbuf:2
	)
	smartcard? ( app-crypt/gcr:4= )
	cups? ( >=net-print/cups-1.4[dbus] )
	modemmanager? (
		>=app-crypt/gcr-3.90.0:4=
		>=net-misc/modemmanager-1.0:=
	)
	networkmanager? ( >=net-misc/networkmanager-1.0 )
	media-libs/alsa-lib
	x11-libs/libXi
	x11-libs/libXext
	media-libs/fontconfig
	systemd? (
		>=sys-apps/systemd-243
	)
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
# logind needed for power and session management, bug #464944
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
"
# rfkill requires linux/rfkill.h, thus linux-headers dep, not os-headers.
# If this package wants to work on other kernels, we need to make rfkill conditional instead
BDEPEND="
	sys-kernel/linux-headers
	dev-util/glib-utils
	dev-util/gdbus-codegen
	${PYTHON_DEPS}
	test? (
		dev-util/umockdev
		$(python_gen_any_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
		gnome-base/gnome-session
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/42.1-build-Make-wacom-optional-and-controllable-via-meson.patch
	"${FILESDIR}"/${PN}-3.38.1-build-Allow-NM-optional-on-Linux.patch
)

python_check_deps() {
	if use test; then
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dudev_dir="$(get_udevdir)"
		$(meson_use systemd)
		-Dalsa=true
		-Dgudev=true
		-Dgcr3=false
		$(meson_use colord)
		$(meson_use cups)
		$(meson_use networkmanager network_manager)
		-Drfkill=true
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
	udev_reload
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	udev_reload
	xdg_pkg_postrm
	gnome2_schemas_update
}
