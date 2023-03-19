# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-control-center"
SRC_URI+=" https://dev.gentoo.org/~mattst88/distfiles/${PN}-43.0-patchset.tar.xz"
SRC_URI+=" https://dev.gentoo.org/~mattst88/distfiles/${PN}-gentoo-logo.svg"
SRC_URI+=" https://dev.gentoo.org/~mattst88/distfiles/${PN}-gentoo-logo-dark.svg"
# Logo is CC-BY-SA-2.5
LICENSE="GPL-2+ CC-BY-SA-2.5"
SLOT="2"
IUSE="+bluetooth +cups debug elogind +gnome-online-accounts +ibus input_devices_wacom kerberos networkmanager systemd test wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	^^ ( elogind systemd )
" # Theoretically "?? ( elogind systemd )" is fine too, lacking some functionality at runtime, but needs testing if handled gracefully enough
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

# meson.build depends on python unconditionally
BDEPEND="${PYTHON_DEPS}"

# kerberos unfortunately means mit-krb5; build fails with heimdal
# display panel requires colord and gnome-settings-daemon[colord]
# wacom panel requires gsd-enums.h from gsd at build time, probably also runtime support
# printer panel requires cups and smbclient (the latter is not patched yet to be separately optional)
# First block is toplevel meson.build deps in order of occurrence (plus deeper deps if in same conditional). Second block is dependency() from subdir meson.builds, sorted by directory name occurrence order
DEPEND="
	gnome-online-accounts? (
		x11-libs/gtk+:3
		>=net-libs/gnome-online-accounts-3.25.3:=
	)
	>=media-libs/libpulse-2.0[glib]
	>=gui-libs/libadwaita-1.2.0:1
	>=sys-apps/accountsservice-0.6.39
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=dev-libs/glib-2.70.0:2
	gnome-base/gnome-desktop:4=
	>=gnome-base/gnome-settings-daemon-41.0[colord,input_devices_wacom?]
	>=gnome-base/gsettings-desktop-schemas-42_alpha
	dev-libs/libxml2:2
	>=sys-power/upower-0.99.8:=
	>=dev-libs/libgudev-232
	x11-libs/libX11
	>=x11-libs/libXi-1.2
	media-libs/libepoxy
	app-crypt/gcr:0=
	>=dev-libs/libpwquality-1.2.2
	>=gui-libs/gtk-4.4:4[X,wayland=]
	>=sys-auth/polkit-0.114
	cups? (
		>=net-print/cups-1.7[dbus]
		>=net-fs/samba-4.0.0[client]
	)
	ibus? ( >=app-i18n/ibus-1.5.2 )
	networkmanager? (
		>=net-libs/libnma-1.8.36
		>=net-misc/networkmanager-1.24.0[modemmanager]
		>=net-misc/modemmanager-0.7.990:=
	)
	bluetooth? ( net-wireless/gnome-bluetooth:3= )
	>=dev-libs/libwacom-0.27:= 
	kerberos? ( app-crypt/mit-krb5 )

	x11-libs/cairo[glib]
	>=x11-libs/colord-gtk-0.3.0:=
	media-libs/fontconfig
	gnome-base/libgtop:2=
	>=sys-fs/udisks-2.1.8:2
	app-crypt/libsecret
	net-libs/gnutls:=
	media-libs/gsound

	x11-libs/pango
"
# media-libs/libcanberra[pulseaudio,sound] needed for Speaker tests in
# Settings/Sound/Output/Output Device, bug #814110
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
RDEPEND="${DEPEND}
	media-libs/libcanberra[pulseaudio,sound]
	systemd? ( >=sys-apps/systemd-31 )
	elogind? (
		app-admin/openrc-settingsd
		sys-auth/elogind
	)
	x11-themes/adwaita-icon-theme
	>=gnome-extra/gnome-color-manager-3.1.2
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper
	)
	>=gnome-base/libgnomekbd-3
	wayland? ( dev-libs/libinput )
	!wayland? (
		>=x11-drivers/xf86-input-libinput-0.19.0
		input_devices_wacom? ( >=x11-drivers/xf86-input-wacom-0.33.0 )
	)
"
# PDEPEND to avoid circular dependency; gnome-session-check-accelerated called by info panel
# gnome-session-2.91.6-r1 also needed so that 10-user-dirs-update is run at login
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1
	networkmanager? ( gnome-extra/nm-applet )" # networking panel can call into nm-connection-editor

BDEPEND="
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	x11-base/xorg-proto
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
		x11-apps/setxkbmap
	)
"

PATCHES=(
	# Patches from gnome-43 branch
	# Makes some panels and dependencies optional
	# https://bugzilla.gnome.org/686840, 697478, 700145
	# Fix some absolute paths to be appropriate for Gentoo
	#"${WORKDIR}"/patches/
)

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
	# Mark python tests with shebang executable, so that meson will launch them directly, instead
	# of via its own python-single-r1 version, which might not match what we get from python_check_deps
	chmod a+x tests/network/test-network-panel.py tests/datetime/test-datetime.py || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation=true # manpage
		$(meson_use ibus)
		-Dprivileged_group=wheel
		-Dsnap=false
		$(meson_use test tests)
		#$(meson_use wayland) # doesn't do anything in 3.34 and 3.36 due to unified gudev handling code
		# bashcompletions installed to $datadir/bash-completion/completions by v3.28.2, which is the same as $(get_bashcompdir)
		-Dmalcontent=false # unpackaged
		-Ddistributor_logo=/usr/share/pixmaps/gnome-control-center-gentoo-logo.svg
		-Ddark_mode_distributor_logo=/usr/share/pixmaps/gnome-control-center-gentoo-logo-dark.svg
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	insinto /usr/share/pixmaps
	doins "${DISTDIR}"/gnome-control-center-gentoo-logo.svg
	doins "${DISTDIR}"/gnome-control-center-gentoo-logo-dark.svg
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
