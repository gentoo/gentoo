# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_6,3_7} )

inherit gnome.org gnome2-utils python-any-r1 meson udev virtualx xdg

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-settings-daemon"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+colord +cups debug elogind input_devices_wacom networkmanager smartcard systemd test +udev wayland"
REQUIRED_USE="
	^^ ( elogind systemd )
	input_devices_wacom? ( udev )
	wayland? ( udev )
"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"

# >=polkit-0.114 for ITS translation rules of .policy files
COMMON_DEPEND="
	>=sci-geosciences/geocode-glib-3.10
	>=dev-libs/glib-2.56:2
	>=gnome-base/gnome-desktop-3.11.1:3=
	>=gnome-base/gsettings-desktop-schemas-3.27.90
	>=x11-libs/gtk+-3.15.3:3[X,wayland?]
	>=dev-libs/libgweather-3.9.5:2=
	colord? (
		>=x11-misc/colord-1.0.2:=
		>=media-libs/lcms-2.2:2 )
	media-libs/libcanberra[gtk3]
	>=app-misc/geoclue-2.3.1:2.0
	>=x11-libs/libnotify-0.7.3
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.114
	>=sys-power/upower-0.99:=
	x11-libs/libX11
	udev? ( dev-libs/libgudev:= )
	wayland? ( dev-libs/wayland )
	input_devices_wacom? ( >=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20.0
		x11-libs/gdk-pixbuf:2 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	cups? ( >=net-print/cups-1.4[dbus] )
	networkmanager? ( >=net-misc/networkmanager-1.0 )
	media-libs/alsa-lib
	x11-libs/libXi
	x11-libs/libXext
	media-libs/fontconfig
"
# logind needed for power and session management, bug #464944
# gnome-session-3.27.90 and gdm-3.27.9 adapt to A11yKeyboard component removal (moved to shell dealing with it)
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
	!<gnome-base/gnome-session-3.27.90
	!<gnome-base/gdm-3.27.90
"
# rfkill requires linux/rfkill.h (and USE=udev), thus linux-headers dep, not os-headers. If this package wants to work on other kernels, we need to make rfkill conditional instead
DEPEND="${COMMON_DEPEND}
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

# Tests go a bit better in 3.26, but still fail some for me; revisit with 3.30+ (incompatible build system python needs until then as well)
#RESTRICT="!test? ( test )"

PATCHES=(
	# Translation updates from gnome-3-30 branch
	# Allow disabling udev and networkmanager on Linux
	# Make colord and wacom optional
	"${WORKDIR}"/patches/
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
		-Dalsa=true
		$(meson_use udev gudev)
		$(meson_use colord)
		$(meson_use cups)
		$(meson_use networkmanager network_manager)
		$(meson_use udev rfkill)
		$(meson_use smartcard)
		$(meson_use input_devices_wacom wacom)
		$(meson_use wayland)
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
