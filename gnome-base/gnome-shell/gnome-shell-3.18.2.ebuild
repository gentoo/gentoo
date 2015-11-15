# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_3,3_4,3_5} )

inherit autotools eutils gnome2 multilib pax-utils python-r1 systemd

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth +networkmanager +nls -openrc-force"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# libXfixes-5.0 needed for pointer barriers
# FIXME:
#  * gstreamer support is currently automagic
COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.5.3
	>=dev-libs/atk-2[introspection]
	>=app-crypt/gcr-3.7.5[introspection]
	>=dev-libs/glib-2.45.3:2[dbus]
	>=dev-libs/gjs-1.39
	>=dev-libs/gobject-introspection-1.45.4:=
	dev-libs/libical:=
	>=x11-libs/gtk+-3.15.0:3[introspection]
	>=media-libs/clutter-1.21.5:1.0[introspection]
	>=dev-libs/json-glib-0.13.2
	>=dev-libs/libcroco-0.6.8:0.6
	>=gnome-base/gnome-desktop-3.7.90:3=[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.14
	>=gnome-base/gnome-keyring-3.3.90
	gnome-base/libgnome-keyring
	>=gnome-extra/evolution-data-server-3.17.2:=
	>=media-libs/gstreamer-0.11.92:1.0
	>=net-im/telepathy-logger-0.2.4[introspection]
	>=net-libs/telepathy-glib-0.19[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=x11-libs/libXfixes-5.0
	x11-libs/libXtst
	>=x11-wm/mutter-3.18.1[introspection]
	>=x11-libs/startup-notification-0.11

	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]

	dev-libs/dbus-glib
	dev-libs/libxml2:2
	gnome-base/librsvg
	media-libs/libcanberra[gtk3]
	media-libs/mesa
	>=media-sound/pulseaudio-2
	>=net-libs/libsoup-2.40:2.4[introspection]
	x11-libs/libX11
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/pango[introspection]
	x11-apps/mesa-progs

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.9[introspection] )
	networkmanager? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-0.9.8
		>=net-misc/networkmanager-0.9.8[introspection] )
"
# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated using:
#  grep -roe "imports.gi.*" gnome-shell-* | cut -f2 -d: | sort | uniq
# Each block:
# 1. Pull in polkit-0.101 for pretty authorization dialogs
# 2. Introspection stuff needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. Systemd needed for suspending support
# 6. xdg-utils needed for xdg-open, used by extension tool
# 7. gnome-icon-theme-symbolic and dejavu font neeed for various icons & arrows
# 8. IBus is needed for nls integration
# 9. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c
RDEPEND="${COMMON_DEPEND}
	>=sys-auth/polkit-0.101[introspection]

	>=app-accessibility/caribou-0.4.8
	media-libs/cogl[introspection]
	>=sys-apps/accountsservice-0.6.14[introspection]
	>=sys-power/upower-0.99[introspection]

	>=gnome-base/gnome-session-2.91.91
	>=gnome-base/gnome-settings-daemon-3.8.3

	!openrc-force? ( >=sys-apps/systemd-31 )

	x11-misc/xdg-utils

	media-fonts/dejavu
	x11-themes/gnome-icon-theme-symbolic

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	nls? ( >=app-i18n/ibus-1.4.99[dconf(+),gtk3,introspection] )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection]
	>=gnome-base/gnome-control-center-3.8.3[bluetooth(+)?,networkmanager(+)?]
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.17
	>=dev-util/intltool-0.40
	gnome-base/gnome-common
	virtual/pkgconfig
	!!=dev-lang/spidermonkey-1.8.2*
"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/show_bug.cgi?id=360413

src_prepare() {
	# Change favorites defaults, bug #479918
	epatch "${FILESDIR}"/${PN}-3.14.0-defaults.patch

	# Fix automagic gnome-bluetooth dep, bug #398145
	epatch "${FILESDIR}"/${PN}-3.12-bluetooth-flag.patch

	# Fix silent bluetooth linking failure with ld.gold, bug #503952
	# https://bugzilla.gnome.org/show_bug.cgi?id=726435
	epatch "${FILESDIR}"/${PN}-3.14.0-bluetooth-gold.patch

	epatch_user

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# Do not error out on warnings
	gnome2_src_configure \
		--enable-browser-plugin \
		--enable-man \
		$(use_enable !openrc-force systemd) \
		$(use_with bluetooth) \
		$(use_enable networkmanager) \
		BROWSER_PLUGIN_DIR="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
}

src_install() {
	gnome2_src_install
	python_replicate_script "${ED}/usr/bin/gnome-shell-extension-tool"
	python_replicate_script "${ED}/usr/bin/gnome-shell-perf-tool"

	# Required for gnome-shell on hardened/PaX, bug #398941
	# Future-proof for >=spidermonkey-1.8.7 following polkit's example
	if has_version '<dev-lang/spidermonkey-1.8.7'; then
		pax-mark mr "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	elif has_version '>=dev-lang/spidermonkey-1.8.7[jit]'; then
		pax-mark m "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	# Required for gnome-shell on hardened/PaX #457146 and #457194
	# PaX EMUTRAMP need to be on
	elif has_version '>=dev-libs/libffi-3.0.13[pax_kernel]'; then
		pax-mark E "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	else
		pax-mark m "${ED}usr/bin/gnome-shell"{,-extension-prefs}
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "apps.gnome-shell.recorder/pipeline to what you want to use."
	fi

	if ! has_version ">=x11-base/xorg-server-1.11"; then
		ewarn "If you use multiple screens, it is highly recommended that you"
		ewarn "upgrade to >=x11-base/xorg-server-1.11 to be able to make use of"
		ewarn "pointer barriers which will make it easier to use hot corners."
	fi

	if has_version "<x11-drivers/ati-drivers-12"; then
		ewarn "GNOME Shell has been reported to show graphical corruption under"
		ewarn "x11-drivers/ati-drivers-11.*; you may want to switch to open-source"
		ewarn "drivers."
	fi

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa."
	fi

	if ! systemd_is_booted; then
		ewarn "${PN} needs Systemd to be *running* for working"
		ewarn "properly. Please follow this guide to migrate:"
		ewarn "https://wiki.gentoo.org/wiki/Systemd"
	fi

	if use openrc-force; then
		ewarn "You are enabling 'openrc-force' USE flag to skip systemd requirement,"
		ewarn "this can lead to unexpected problems and is not supported neither by"
		ewarn "upstream neither by Gnome Gentoo maintainers. If you suffer any problem,"
		ewarn "you will need to disable this USE flag system wide and retest before"
		ewarn "opening any bug report."
	fi
}
