# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"
#PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} ) # https://bugzilla.gnome.org/show_bug.cgi?id=783186
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-any-r1 udev virtualx

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://git.gnome.org/browse/gnome-settings-daemon"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord +cups debug elogind input_devices_wacom networkmanager policykit smartcard systemd test +udev wayland"
REQUIRED_USE="
	^^ ( elogind systemd )
	input_devices_wacom? ( udev )
	smartcard? ( udev )
	wayland? ( udev )
"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"

COMMON_DEPEND="
	>=dev-libs/glib-2.53.0:2
	>=x11-libs/gtk+-3.15.3:3[X,wayland?]
	>=gnome-base/gnome-desktop-3.11.1:3=
	>=gnome-base/gsettings-desktop-schemas-3.23.3
	>=gnome-base/librsvg-2.36.2:2
	media-fonts/cantarell
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-2
	>=sys-power/upower-0.99:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.3:=
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/libXxf86misc
	x11-misc/xkeyboard-config

	>=app-misc/geoclue-2.3.1:2.0
	>=dev-libs/libgweather-3.9.5:2=
	>=sci-geosciences/geocode-glib-3.10
	>=sys-auth/polkit-0.103

	colord? (
		>=media-libs/lcms-2.2:2
		>=x11-misc/colord-1.0.2:= )
	cups? ( >=net-print/cups-1.4[dbus] )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20
		x11-drivers/xf86-input-wacom
		virtual/libgudev:= )
	networkmanager? ( >=net-misc/networkmanager-1.0 )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( virtual/libgudev:= )
	wayland? ( dev-libs/wayland )
"
# logind needed for power and session management, bug #464944
# gnome-session-3.25.4 adapts to Orientation and XRANDR components removal (moved to mutter)
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
	!<gnome-base/gnome-session-3.25.4
"
DEPEND="${COMMON_DEPEND}
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	dev-libs/libxml2:2
	dev-util/glib-utils
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-base/xorg-proto
"

# Tests go a bit better in 3.26, but still fail some for me; revisit with 3.28+
RESTRICT="!test? ( test )"

PATCHES=(
	# upstream gnome-3-26 branch up to its abandonment in February 2018 (many unreleased fixes); requires eautoreconf
	# Make colord and wacom optional; requires eautoreconf
	# Allow specifying udevrulesdir via configure, bug 509484; requires eautoreconf
	# Fix build system to require gudev with wayland, bug #627966; requires eautoreconf
	"${WORKDIR}"/patches/
)

python_check_deps() {
	if use test; then
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-udevrulesdir="$(get_udevdir)"/rules.d \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable debug more-warnings) \
		$(use_enable networkmanager network-manager) \
		$(use_enable smartcard smartcard-support) \
		$(use_enable udev gudev) \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable wayland)
}

src_test() {
	virtx emake check
}
