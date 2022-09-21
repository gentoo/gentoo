# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome.org gnome2-utils meson python-single-r1 virtualx xdg

DESCRIPTION="Provides core UI functions for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell https://gitlab.gnome.org/GNOME/gnome-shell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth +browser-extension elogind gtk-doc +ibus +networkmanager systemd telepathy test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )"
RESTRICT="!test? ( test )"

KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

# libXfixes-5.0 needed for pointer barriers and #include <X11/extensions/Xfixes.h>
# FIXME:
#  * gstreamer/pipewire support is currently automagic
DEPEND="
	>=gnome-extra/evolution-data-server-3.33.1:=
	>=app-crypt/gcr-3.7.5:=[introspection]
	>=dev-libs/glib-2.68:2
	>=dev-libs/gobject-introspection-1.49.1:=
	>=dev-libs/gjs-1.71.1[cairo]
	>=x11-libs/gtk+-3.15.0:3[introspection]
	>=x11-wm/mutter-42.0:0/10[introspection,test?]
	>=sys-auth/polkit-0.120_p20220509[introspection]
	>=gnome-base/gsettings-desktop-schemas-42_beta[introspection]
	>=x11-libs/startup-notification-0.11
	>=app-i18n/ibus-1.5.19
	>=gnome-base/gnome-desktop-3.35.90:3=[introspection]
	bluetooth? ( net-wireless/gnome-bluetooth:3=[introspection] )
	>=media-libs/gstreamer-0.11.92:1.0
	media-libs/gst-plugins-base:1.0
	>=media-video/pipewire-0.3.0:=
	networkmanager? (
		>=net-misc/networkmanager-1.10.4[introspection]
		net-libs/libnma[introspection]
		>=app-crypt/libsecret-0.18
		dev-libs/dbus-glib
	)
	systemd? (
		>=sys-apps/systemd-242:=
		>=gnome-base/gnome-desktop-3.34.2:3=[systemd]
	)
	elogind? ( >=sys-auth/elogind-237 )

	app-arch/gnome-autoar
	dev-libs/json-glib

	>=app-accessibility/at-spi2-atk-2.5.3:2
	x11-libs/gdk-pixbuf:2[introspection]
	dev-libs/libxml2:2
	x11-libs/libX11

	>=media-libs/libpulse-2[glib]
	>=dev-libs/atk-2[introspection]
	dev-libs/libical:=
	>=x11-libs/libXfixes-5.0

	gui-libs/gtk:4[introspection]

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	media-libs/mesa[X(+)]
"
# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated from inspection of the output of:
#  for i in `rg -INUo 'const(?s).*imports.gi' |cut -d= -f1 |cut -c7- |sort -u`; do echo $i ;done |cut -d, -f1 |sort -u
# or
#  rg -INUo 'const(?s).*imports.gi' |cut -d= -f1 |cut -c7- | sed -e 's:[{}]::g' | awk '{$1=$1; print}' | awk -F',' '{$1=$1;print}' | tr ' ' '\n' | sort -u | sed -e 's/://g'
# These will give a lot of unnecessary things due to greedy matching (TODO), and `(?s).*?` doesn't seem to work as desired.
# Compare with `grep -rhI 'imports.gi.versions' |sort -u` for any SLOT requirements
# Each block:
# 1. Introspection stuff needed via imports.gi (those that build time check may be listed above already)
# 2. gnome-session needed for shutdown/reboot/inhibitors/etc
# 3. Control shell settings
# 4. xdg-utils needed for xdg-open, used by extension tool
# 5. adwaita-icon-theme needed for various icons & arrows (3.26 for new video-joined-displays-symbolic and co icons; review for 3.28+)
# 6. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c  # TODO: Review
# 7. IBus is needed for nls integration
# 8. Optional telepathy chat integration
# 9. Cantarell font used in gnome-shell global CSS (if removing this for some reason, make sure it's pulled in somehow for non-meta users still too)
# 10. xdg-desktop-portal-gtk for various integration, e.g. #764632
# 11. TODO: semi-optional webkit-gtk[introspection] for captive portal helper
RDEPEND="${DEPEND}
	>=sys-apps/accountsservice-0.6.14[introspection]
	app-accessibility/at-spi2-core:2[introspection]
	app-misc/geoclue[introspection]
	media-libs/graphene[introspection]
	>=dev-libs/libgweather-4.0.0:4[introspection]
	x11-libs/pango[introspection]
	net-libs/libsoup:2.4[introspection]
	>=sys-power/upower-0.99:=[introspection]
	gnome-base/librsvg:2[introspection]

	>=gnome-base/gnome-session-2.91.91
	>=gnome-base/gnome-settings-daemon-3.8.3

	x11-misc/xdg-utils

	>=x11-themes/adwaita-icon-theme-3.26

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data
	)
	ibus? ( >=app-i18n/ibus-1.5.26[gtk3,gtk4,introspection] )
	telepathy? (
		>=net-im/telepathy-logger-0.2.4[introspection]
		>=net-libs/telepathy-glib-0.19[introspection]
	)
	media-fonts/cantarell

	|| ( sys-apps/xdg-desktop-portal-gnome <sys-apps/xdg-desktop-portal-gtk-1.14.0 )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection(+)]
	>=gnome-base/gnome-control-center-3.26[bluetooth(+)?,networkmanager(+)?]
	browser-extension? ( gnome-extra/gnome-browser-connector )
"
BDEPEND="
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.45.3
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.17
		app-text/docbook-xml-dtd:4.5 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
# These are not needed from tarballs, unless stylesheets or manpage get patched with patchset:
# dev-lang/sassc
# app-text/asciidoc

PATCHES=(
	# Fix automagic gnome-bluetooth dep, bug #398145
	"${FILESDIR}"/42.0-optional-bluetooth.patch
	# Change favorites defaults, bug #479918
	"${FILESDIR}"/40.0-defaults.patch
)

src_prepare() {
	default
	xdg_environment_reset
	# Hack in correct python shebang
	sed -e "s:python\.full_path():'/usr/bin/env ${EPYTHON}':" -i src/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_use bluetooth)
		-Dextensions_tool=true
		-Dextensions_app=true
		$(meson_use gtk-doc gtk_doc)
		-Dman=true
		$(meson_use test tests)
		$(meson_use networkmanager)
		$(meson_use systemd) # this controls journald integration and desktop file user services related property only as of 3.34.4
		# (structured logging and having gnome-shell launched apps use its own identifier instead of gnome-session)
		# suspend support is runtime optional via /run/systemd/seats presence and org.freedesktop.login1.Manager dbus interface; elogind should provide what's necessary
		-Dsoup2=true # libslot SLOT needs to match with what libgweather is using
	)
	meson_src_configure
}

src_test() {
	gnome2_environment_reset # Avoid dconf that looks at XDG_DATA_DIRS, which can sandbox fail if flatpak is installed
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
