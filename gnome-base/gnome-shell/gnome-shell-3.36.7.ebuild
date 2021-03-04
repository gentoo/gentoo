# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit gnome.org gnome2-utils meson python-single-r1 virtualx xdg

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${PF}-patchset.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth +browser-extension elogind gtk-doc +ibus +networkmanager systemd telepathy"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )"

KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 x86"

# libXfixes-5.0 needed for pointer barriers and #include <X11/extensions/Xfixes.h>
# FIXME:
#  * gstreamer support is currently automagic
DEPEND="
	>=gnome-extra/evolution-data-server-3.33.1:=
	>=app-crypt/gcr-3.7.5[introspection]
	>=dev-libs/glib-2.57.2:2
	>=dev-libs/gobject-introspection-1.49.1:=
	>=dev-libs/gjs-1.63.2
	>=x11-libs/gtk+-3.15.0:3[introspection]
	>=x11-wm/mutter-3.36.0:0/6[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.33.1
	>=x11-libs/startup-notification-0.11
	>=app-i18n/ibus-1.5.2
	>=gnome-base/gnome-desktop-3.35.90:3=[introspection]
	bluetooth? ( >=net-wireless/gnome-bluetooth-3.9[introspection] )
	>=media-libs/gstreamer-0.11.92:1.0
	media-libs/gst-plugins-base:1.0
	networkmanager? (
		>=net-misc/networkmanager-1.10.4:=[introspection]
		net-libs/libnma[introspection]
		>=app-crypt/libsecret-0.18
		dev-libs/dbus-glib )
	systemd? ( >=sys-apps/systemd-31
		>=gnome-base/gnome-desktop-3.34.2:3=[systemd] )
	elogind? ( >=sys-auth/elogind-237 )
	app-arch/gnome-autoar
	dev-libs/json-glib

	>=app-accessibility/at-spi2-atk-2.5.3
	x11-libs/gdk-pixbuf:2[introspection]
	dev-libs/libxml2:2
	x11-libs/libX11

	>=media-sound/pulseaudio-12.99.3[glib]
	>=dev-libs/atk-2[introspection]
	dev-libs/libical:=
	>=x11-libs/libXfixes-5.0

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
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
# 10. Cantarell font used in gnome-shell global CSS (if removing this for some reason, make sure it's pulled in somehow for non-meta users still too)
# 11. TODO: semi-optional webkit-gtk[introspection] for captive portal helper
RDEPEND="${DEPEND}
	>=sys-apps/accountsservice-0.6.14[introspection]
	app-accessibility/at-spi2-core:2[introspection]
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
	media-fonts/cantarell
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection]
	>=gnome-base/gnome-control-center-3.26[bluetooth(+)?,networkmanager(+)?]
	browser-extension? ( gnome-extra/chrome-gnome-shell )
"
BDEPEND="
	dev-lang/sassc
	dev-libs/libxslt
	app-text/asciidoc
	>=dev-util/gdbus-codegen-2.45.3
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.17
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# origin/gnome-3-36@03062d0d9d9f + try to fix crashes related to custom stylesheet; triggered often by package installs (probably desktop database update), screen unlock, etc
	# https://gitlab.gnome.org/GNOME/gnome-shell/issues/1265
	# https://gitlab.gnome.org/GNOME/gnome-shell/merge_requests/536
	"${WORKDIR}"/patches
	# Fix automagic gnome-bluetooth dep, bug #398145
	"${FILESDIR}"/3.34-optional-bluetooth.patch
	# Change favorites defaults, bug #479918
	"${FILESDIR}"/3.36-defaults.patch
)

src_prepare() {
	xdg_src_prepare
	# Hack in correct python shebang
	sed -e "s:python\.path():'/usr/bin/env ${EPYTHON}':" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use bluetooth)
		-Dextensions_tool=true
		-Dextensions_app=true
		$(meson_use gtk-doc gtk_doc)
		-Dman=true
		$(meson_use networkmanager)
		$(meson_use systemd) # this controls journald integration and desktop file user services related property only as of 3.34.4
		# (structured logging and having gnome-shell launched apps use its own identifier instead of gnome-session)
		# suspend support is runtime optional via /run/systemd/seats presence and org.freedesktop.login1.Manager dbus interface; elogind should provide what's necessary
	)
	meson_src_configure
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
	# TODO: Is this still the case after various fixed in 3.28 for detecting non-working KMS for wayland (to fall back to X)?
	if has_version "x11-drivers/nvidia-drivers[-kms]"; then
		ewarn "You will need to enable kms support in x11-drivers/nvidia-drivers,"
		ewarn "otherwise Gnome will fail to start"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
