# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit bash-completion-r1 gnome2

DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-control-center/"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="2"
IUSE="+bluetooth +colord +cups debug +gnome-online-accounts +ibus input_devices_wacom kerberos networkmanager v4l wayland"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"

# gnome-session-2.91.6-r1 is needed so that 10-user-dirs-update is run at login
# g-s-d[policykit] needed for bug #403527
# kerberos unfortunately means mit-krb5; build fails with heimdal
# udev could be made optional, only conditions gsd-device-panel
# (mouse, keyboards, touchscreen, etc)
# display panel requires colord and gnome-settings-daemon[colord]
# printer panel requires cups and smbclient (the latter is not patch yet to be separately optional)
COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2[dbus]
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.22.0:3[X,wayland?]
	>=gnome-base/gsettings-desktop-schemas-3.21.4
	>=gnome-base/gnome-desktop-3.21.2:3=
	>=gnome-base/gnome-settings-daemon-3.23.90[colord,policykit]
	>=x11-misc/colord-0.1.34:0=

	>=dev-libs/libpwquality-1.2.2
	dev-libs/libxml2:2
	gnome-base/libgtop:2=
	media-libs/fontconfig
	>=sys-apps/accountsservice-0.6.39

	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-2[glib]
	>=sys-auth/polkit-0.97
	>=sys-power/upower-0.99:=

	virtual/libgudev
	x11-apps/xmodmap
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXxf86misc
	>=x11-libs/libXi-1.2

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.18.2:= )
	colord? (
		net-libs/libsoup:2.4
		>=x11-misc/colord-0.1.34:0=
		>=x11-libs/colord-gtk-0.1.24 )
	cups? (
		>=net-print/cups-1.7[dbus]
		>=net-fs/samba-4.0.0[client]
	)
	gnome-online-accounts? (
		>=media-libs/grilo-0.3.0:0.3=
		>=net-libs/gnome-online-accounts-3.21.5:= )
	ibus? ( >=app-i18n/ibus-1.5.2 )
	kerberos? ( app-crypt/mit-krb5 )
	networkmanager? (
		>=gnome-extra/nm-applet-1.2.0
		>=net-misc/networkmanager-1.2.0:=[modemmanager]
		>=net-misc/modemmanager-0.7.990 )
	v4l? (
		media-libs/clutter-gtk:1.0
		>=media-video/cheese-3.5.91 )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=media-libs/clutter-1.11.3:1.0
		media-libs/clutter-gtk:1.0
		>=x11-libs/libXi-1.2 )
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
# libgnomekbd needed only for gkbd-keyboard-display tool
#
# mouse panel needs a concrete set of X11 drivers at runtime, bug #580474
# Also we need newer driver versions to allow wacom and libinput drivers to
# not collide
#
# system-config-printer provides org.fedoraproject.Config.Printing service and interface
# cups-pk-helper provides org.opensuse.cupspkhelper.mechanism.all-edit policykit helper policy
RDEPEND="${COMMON_DEPEND}
	|| ( >=sys-apps/systemd-31 ( app-admin/openrc-settingsd sys-auth/consolekit ) )
	x11-themes/adwaita-icon-theme
	colord? ( >=gnome-extra/gnome-color-manager-3 )
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	input_devices_wacom? ( gnome-base/gnome-settings-daemon[input_devices_wacom] )
	>=gnome-base/libgnomekbd-3
	wayland? ( dev-libs/libinput )
	!wayland? (
		>=x11-drivers/xf86-input-libinput-0.19.0
		input_devices_wacom? ( >=x11-drivers/xf86-input-wacom-0.33.0 ) )

	!<gnome-base/gdm-2.91.94
	!<gnome-extra/gnome-color-manager-3.1.2
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2
"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"

DEPEND="${COMMON_DEPEND}
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig

	gnome-base/gnome-common
	sys-devel/autoconf-archive
"
# Needed for autoreconf
#	gnome-base/gnome-common
#	sys-devel/autoconf-archive

PATCHES=(
	# Makes some panels and dependencies optional; requires eautoreconf
	# https://bugzilla.gnome.org/686840, 697478, 700145
	# Fix some absolute paths to be appropriate for Gentoo
	"${WORKDIR}"/patches/
)

src_configure() {
	gnome2_src_configure \
		--disable-update-mimedb \
		--disable-static \
		--enable-documentation \
		$(use_enable bluetooth) \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable ibus) \
		$(use_enable kerberos) \
		$(use_enable networkmanager) \
		$(use_with v4l cheese) \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable wayland)
}

src_install() {
	gnome2_src_install completiondir="$(get_bashcompdir)"
}
