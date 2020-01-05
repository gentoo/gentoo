# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit gnome.org gnome2-utils meson pax-utils python-single-r1 virtualx xdg

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth +browser-extension elogind +ibus +networkmanager nsplugin systemd telepathy"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"

# libXfixes-5.0 needed for pointer barriers and #include <X11/extensions/Xfixes.h>
# FIXME:
#  * gstreamer support is currently automagic
COMMON_DEPEND="
	>=dev-libs/libcroco-0.6.8:0.6
	>=gnome-extra/evolution-data-server-3.17.2:=
	>=app-crypt/gcr-3.7.5[introspection]
	>=gnome-base/gnome-desktop-3.7.90:3=[introspection]
	>=dev-libs/glib-2.53.0:2
	>=dev-libs/gobject-introspection-1.49.1:=
	>=dev-libs/gjs-1.47.0
	<dev-libs/gjs-1.53
	>=x11-libs/gtk+-3.15.0:3[introspection]
	nsplugin? ( >=dev-libs/json-glib-0.13.2 )
	>=x11-wm/mutter-3.24.0:0/1[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.21.3
	>=x11-libs/startup-notification-0.11
	bluetooth? ( >=net-wireless/gnome-bluetooth-3.9[introspection] )
	>=media-libs/gstreamer-0.11.92:1.0
	networkmanager? (
		>=gnome-extra/nm-applet-0.9.8[introspection]
		>=net-misc/networkmanager-0.9.8:=[introspection]
		>=app-crypt/libsecret-0.18
		dev-libs/dbus-glib )
	systemd? ( >=sys-apps/systemd-31 )
	elogind? ( >=sys-auth/elogind-237 )

	>=app-accessibility/at-spi2-atk-2.5.3
	media-libs/libcanberra[gtk3]
	x11-libs/gdk-pixbuf:2[introspection]
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.40:2.4[introspection]
	x11-libs/libX11

	>=media-sound/pulseaudio-2[glib]
	>=dev-libs/atk-2[introspection]
	dev-libs/libical:=
	>=x11-libs/libXfixes-5.0

	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	media-libs/mesa[X(+)]
"
# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated using:
#  grep -roe "imports.gi.*" gnome-shell-* | cut -f2 -d: | sort | uniq
# Each block:
# 1. Introspection stuff needed via imports.gi.*
# 2. gnome-session needed for shutdown/reboot/inhibitors/etc
# 3. Control shell settings
# 4. logind interface needed for suspending support
# 5. xdg-utils needed for xdg-open, used by extension tool
# 6. adwaita-icon-theme needed for various icons & arrows (3.26 for new video-joined-displays-symbolic and co icons; review for 3.28+)
# 7. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c  # TODO: Review
# 8. IBus is needed for nls integration
# 9. Optional telepathy chat integration
# 10. TODO: semi-optional webkit-gtk[introspection] for captive portal helper
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/accountsservice-0.6.14[introspection]
	app-accessibility/at-spi2-core:2[introspection]
	>=app-accessibility/caribou-0.4.8
	app-misc/geoclue[introspection]
	>=dev-libs/libgweather-3.26:2[introspection]
	>=sys-power/upower-0.99:=[introspection]
	x11-libs/pango[introspection]
	gnome-base/librsvg:2[introspection]

	>=gnome-base/gnome-session-2.91.91
	>=gnome-base/gnome-settings-daemon-3.8.3

	x11-misc/xdg-utils

	>=x11-themes/adwaita-icon-theme-3.26

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	ibus? ( >=app-i18n/ibus-1.4.99[dconf(+),gtk,introspection] )
	telepathy? (
		>=net-im/telepathy-logger-0.2.4[introspection]
		>=net-libs/telepathy-glib-0.19[introspection] )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection]
	>=gnome-base/gnome-control-center-3.26[bluetooth(+)?,networkmanager(+)?]
	browser-extension? ( gnome-extra/chrome-gnome-shell )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.45.3
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
" #gtk-doc? ( >=dev-util/gtk-doc-1.17 )

PATCHES=(
	# Patches from gnome-3-26 branch on top of 3.26.2
	"${WORKDIR}"/patches/
	# Change favorites defaults, bug #479918
	"${FILESDIR}"/${PN}-3.22.0-defaults.patch
	# Fix automagic gnome-bluetooth dep, bug #398145
	"${FILESDIR}"/3.26-optional-bluetooth.patch
)

src_prepare() {
	xdg_src_prepare
	# We want nsplugins in /usr/$(get_libdir)/nsbrowser/plugins not .../mozilla/plugins
	sed -e 's/mozilla/nsbrowser/' -i meson.build || die
	# Hack in correct python shebang
	sed -e "s:python\.path():'/usr/bin/env ${EPYTHON}':" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use nsplugin enable-browser-plugin)
		#$(meson_use gtk-doc enable-documentation) # fails in gtkdoc-scangobj call with gtk-doc-1.25 (perl regex parenthesis issue); probably needs newer python-based gtk-doc to work
		-Denable-man=true
		-Denable-bluetooth=$(usex bluetooth yes no)
		-Denable-networkmanager=$(usex networkmanager yes no)
		-Denable-systemd=$(usex systemd yes no) # this controls journald integration only as of 3.26.2 (structured logging and having gnome-shell launched apps use its own identifier instead of gnome-session)
		# suspend support is runtime optional via /run/systemd/seats presence and org.freedesktop.login1.Manager dbus interface; elogind should provide what's necessary
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# Required for gnome-shell on hardened/PaX, bug #398941; FIXME: Is this still relevant?
	pax-mark m "${ED}usr/bin/gnome-shell"{,-extension-prefs}
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "apps.gnome-shell.recorder/pipeline to what you want to use."
	fi

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa if you do not have hardware 3D setup."
	fi

	# https://bugs.gentoo.org/show_bug.cgi?id=563084
	if has_version "x11-drivers/nvidia-drivers[-kms]"; then
		ewarn "You will need to enable kms support in x11-drivers/nvidia-drivers,"
		ewarn "otherwise Gnome will fail to start"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
