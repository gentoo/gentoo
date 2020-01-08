# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-control-center/"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="2"
IUSE="+bluetooth +cups debug elogind flickr +gnome-online-accounts +ibus input_devices_wacom kerberos networkmanager systemd v4l wayland"
REQUIRED_USE="
	flickr? ( gnome-online-accounts )
	^^ ( elogind systemd )
" # Theoretically "?? ( elogind systemd )" is fine too, lacking some functionality at runtime, but needs testing if handled gracefully enough
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh x86 ~amd64-linux ~x86-linux ~x86-solaris"

# kerberos unfortunately means mit-krb5; build fails with heimdal
# display panel requires colord and gnome-settings-daemon[colord]
# wacom panel requires gsd-enums.h from gsd at build time, probably also runtime support
# printer panel requires cups and smbclient (the latter is not patched yet to be separately optional)
# >=polkit-0.114 for .policy files gettext ITS
clutter_gtk_dep="media-libs/clutter-gtk:1.0"
# First block is toplevel meson.build deps in order of occurrence (plus deeper deps if in same conditional). Second block is dependency() from subdir meson.builds, sorted by directory name occurrence order
COMMON_DEPEND="
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.25.3:= )
	>=media-sound/pulseaudio-2.0[glib]
	>=sys-apps/accountsservice-0.6.39
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=dev-libs/glib-2.53.0:2
	>=gnome-base/gnome-desktop-3.27.90:3=
	>=gnome-base/gnome-settings-daemon-3.25.90[colord,input_devices_wacom?]
	>=gnome-base/gsettings-desktop-schemas-3.27.2
	dev-libs/libxml2:2
	>=sys-auth/polkit-0.114
	>=sys-power/upower-0.99.6:=
	x11-libs/libX11
	>=x11-libs/libXi-1.2
	flickr? ( >=media-libs/grilo-0.3.0:0.3= )
	>=x11-libs/gtk+-3.22.0:3[X,wayland=]
	cups? (
		>=net-print/cups-1.7[dbus]
		>=net-fs/samba-4.0.0[client]
	)
	v4l? (
		${clutter_gtk_dep}
		>=media-video/cheese-3.28.0 )
	ibus? ( >=app-i18n/ibus-1.5.2 )
	wayland? ( dev-libs/libgudev )
	networkmanager? (
		>=gnome-extra/nm-applet-1.8.0
		>=net-misc/networkmanager-1.10.0:=[modemmanager]
		>=net-misc/modemmanager-0.7.990 )
	bluetooth? ( >=net-wireless/gnome-bluetooth-3.18.2:= )
	input_devices_wacom? (
		${clutter_gtk_dep}
		>=dev-libs/libwacom-0.27
		>=media-libs/clutter-1.11.3:1.0 )
	kerberos? ( app-crypt/mit-krb5 )

	x11-libs/cairo[glib]
	>=x11-libs/colord-gtk-0.1.24
	net-libs/libsoup:2.4
	media-libs/fontconfig
	gnome-base/libgtop:2=
	app-crypt/libsecret
	>=media-libs/libcanberra-0.13[gtk3]
	>=dev-libs/libpwquality-1.2.2
"
# systemd/elogind USE flagged because package manager will potentially try to satisfy a
# "|| ( systemd ( elogind openrc-settingsd)" via systemd if openrc-settingsd isn't already installed.
# libgnomekbd needed only for gkbd-keyboard-display tool
# gnome-color-manager needed for gcm-calibrate and gcm-viewer calls from color panel
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
#
# mouse panel needs a concrete set of X11 drivers at runtime, bug #580474
# Also we need newer driver versions to allow wacom and libinput drivers to
# not collide
#
# system-config-printer provides org.fedoraproject.Config.Printing service and interface
# cups-pk-helper provides org.opensuse.cupspkhelper.mechanism.all-edit policykit helper policy
RDEPEND="${COMMON_DEPEND}
	systemd? ( >=sys-apps/systemd-31 )
	elogind? ( app-admin/openrc-settingsd
		sys-auth/elogind )
	x11-themes/adwaita-icon-theme
	>=gnome-extra/gnome-color-manager-3.1.2
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	>=gnome-base/libgnomekbd-3
	wayland? ( dev-libs/libinput )
	!wayland? (
		>=x11-drivers/xf86-input-libinput-0.19.0
		input_devices_wacom? ( >=x11-drivers/xf86-input-wacom-0.33.0 ) )
	flickr? ( media-plugins/grilo-plugins:0.3[flickr,gnome-online-accounts] )

	!<gnome-base/gdm-2.91.94
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2
"
# PDEPEND to avoid circular dependency; gnome-session-check-accelerated called by info panel
# gnome-session-2.91.6-r1 also needed so that 10-user-dirs-update is run at login
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	x11-base/xorg-proto
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Patches from gnome-3-28 branch on top of 3.28.2
	# Makes some panels and dependencies optional
	# https://bugzilla.gnome.org/686840, 697478, 700145
	# Fix some absolute paths to be appropriate for Gentoo
	"${WORKDIR}"/patches/
	# Extra patch to fix incomplete USE=-cups support in patchset; amend it into the cups optionality commit for next patchset
	"${FILESDIR}"/${PV}-conditional-cups-tests.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use bluetooth)
		$(meson_use v4l cheese)
		-Dcups=$(usex cups enabled disabled)
		-Ddocumentation=true # manpage
		-Dgoa=$(usex gnome-online-accounts enabled disabled)
		-Dgrilo=$(usex flickr enabled disabled)
		$(meson_use ibus)
		-Dkerberos=$(usex kerberos enabled disabled)
		$(meson_use networkmanager network_manager)
		-Dtracing=false
		$(meson_use input_devices_wacom wacom)
		$(meson_use wayland)
		# bashcompletions installed to $datadir/bash-completion/completions by v3.28.2, which is the same as $(get_bashcompdir)
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
