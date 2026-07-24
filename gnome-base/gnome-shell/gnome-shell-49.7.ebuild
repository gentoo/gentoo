# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic gnome.org gnome2-utils meson optfeature python-single-r1 xdg

DESCRIPTION="Provides core UI functions for the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-shell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

IUSE="X elogind gtk-doc +ibus +networkmanager pipewire selinux systemd test wayland"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )"
RESTRICT="!test? ( test )"

# libXfixes-5.0 needed for pointer barriers and #include <X11/extensions/Xfixes.h>
DEPEND="
	>=gnome-extra/evolution-data-server-3.46.0:=
	>=app-crypt/gcr-3.90.0:4=[introspection]
	>=dev-libs/glib-2.86.0:2
	>=dev-libs/gobject-introspection-1.86.0:=
	>=dev-libs/gjs-1.85.90[cairo(+)]
	>=gui-libs/gtk-4:4[X?,introspection,wayland?]
	>=x11-wm/mutter-49.0:0/17[introspection,test?]
	>=sys-auth/polkit-0.120_p20220509[introspection]
	>=gnome-base/gsettings-desktop-schemas-49_alpha[introspection]
	X? (
		x11-libs/libX11
		x11-libs/libXext
		>=x11-libs/libXfixes-5.0
	)
	>=app-i18n/ibus-1.5.19
	dev-python/docutils
	>=gnome-base/gnome-desktop-40.0:4=
	networkmanager? (
		>=net-misc/networkmanager-1.10.4[introspection]
		net-libs/libnma[introspection]
		>=app-crypt/libsecret-0.18
	)
	pipewire? ( >=media-video/pipewire-0.3.49:= )
	systemd? (
		>=sys-apps/systemd-246:=
		>=gnome-base/gnome-desktop-3.34.2:3=[systemd]
	)
	elogind? ( >=sys-auth/elogind-237 )

	app-arch/gnome-autoar
	dev-libs/json-glib
	net-libs/libsoup:3.0

	>=app-accessibility/at-spi2-core-2.46:2[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	dev-libs/libxml2:2=

	>=media-libs/libpulse-2[glib]
	dev-libs/libical:=

	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	media-libs/libglvnd[X]
"
# Runtime-only deps are probably incomplete and approximate.
# Introspection deps generated from inspection of the output of:
#  for i in `rg -INUo 'const(?s).*imports.gi' |cut -d= -f1 |cut -c7- |sort -u`; do echo $i ;done |cut -d, -f1 |sort -u
# or
#  rg -INUo 'const(?s).*imports.gi' |cut -d= -f1 |cut -c7- | sed -e 's:[{}]::g' | awk '{$1=$1; print}' | \
#    awk -F',' '{$1=$1;print}' | tr ' ' '\n' | sort -u | sed -e 's/://g'
# These will give a lot of unnecessary things due to greedy matching (TODO), and `(?s).*?` doesn't seem to work as
# desired.
# Compare with `grep -rhI 'imports.gi.versions' |sort -u` for any SLOT requirements
# Each block:
# 1. Introspection stuff needed via imports.gi (those that build time check may be listed above already)
# 2. gnome-session needed for shutdown/reboot/inhibitors/etc
# 3. Control shell settings
# 4. xdg-utils needed for xdg-open, used by extension tool
# 5. adwaita-icon-theme needed for various icons & arrows
# 6. mobile-broadband-provider-info, timezone-data for shell-mobile-providers.c  # TODO: Review
# 7. IBus is needed for nls integration
# 8. Adwaita font used in gnome-shell global CSS (if removing this make sure it's pulled in somehow for non-meta users)
# 9. xdg-desktop-portal-gtk for various integration, e.g. #764632
# 10. TODO: semi-optional webkit-gtk[introspection] for captive portal helper
RDEPEND="${DEPEND}
	>=sys-apps/accountsservice-0.6.14[introspection]
	app-accessibility/at-spi2-core:2[introspection]
	app-misc/geoclue:2.0[introspection]
	media-libs/graphene[introspection]
	>=x11-libs/pango-1.46.0[introspection]
	net-libs/libsoup:3.0[introspection]
	>=sys-power/upower-0.99:=[introspection]
	gnome-base/librsvg:2[introspection]
	gui-libs/libadwaita:1[introspection]

	>=gnome-base/gnome-session-49
	>=gnome-base/gnome-settings-daemon-3.8.3

	x11-misc/xdg-utils

	>=x11-themes/adwaita-icon-theme-3.26

	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data
	)
	ibus? ( >=app-i18n/ibus-1.5.26[gtk3,gtk4,introspection] )
	selinux? ( sec-policy/selinux-wm )
	media-fonts/adwaita-fonts

	sys-apps/xdg-desktop-portal-gnome
"

# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-49[introspection(+)]
	>=gnome-base/gnome-control-center-3.26[networkmanager(+)?]
"
BDEPEND="
	>=dev-build/meson-1.3.0
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.17
		>=dev-util/gi-docgen-2021.1
		app-text/docbook-xml-dtd:4.5
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		sys-apps/dbus
		x11-wm/mutter[test]
	)
"
# These are not needed from tarballs, unless stylesheets or manpage get patched with patchset:
# dev-lang/sassc
# app-text/asciidoc

PATCHES=(
	"${FILESDIR}"/0001-shell-elogind-support-to-avoid-stubbed-sd_notify.patch
)

src_prepare() {
	default
	xdg_environment_reset
	# Hack in correct python shebang
	sed -e "s:python\.full_path():'/usr/bin/env ${EPYTHON}':" -i src/meson.build || die
}

src_configure() {
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		$(meson_use pipewire camera_monitor)
		-Dextensions_tool=true
		-Dextensions_app=true
		$(meson_use gtk-doc gtk_doc)
		-Dman=true
		$(meson_use test tests)
		$(meson_use networkmanager)
		$(meson_use networkmanager portal_helper)
		$(meson_use systemd)
	)
	meson_src_configure
}

src_test() {
	# Some tests fail when /var/tmp/portage is used as PORTAGE_TMPDIR
	# due to PATH becoming too long: OSError: AF_UNIX path too long
	# Intercept system mutter_dbusrunner.py to shorten the paths.

	local custom_mutter="${T}/custom-mutter"
	mkdir -p "${custom_mutter}" || die
	cp -r "${EPREFIX}"/usr/share/mutter-[0-9]*/tests/* "${custom_mutter}/" || die

	sed -i -e "s/prefix='mutter-testroot-'/prefix='m-'/g" \
		-e "s/'xdg_runtime_dir'/'run'/g" \
		"${custom_mutter}/mutter_dbusrunner.py" || die

	sed -i -e "s|/usr/share/mutter-[0-9]*/tests|${custom_mutter}|g" \
		"${BUILD_DIR}/tests/gnome-shell-dbus-runner.py" || die

	meson_src_test
}

src_install() {
	meson_src_install
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html || die
		mv "${ED}"/usr/share/doc/{st,shell} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa if you do not have hardware 3D setup."
	fi

	optfeature "Bluetooth integration" gnome-base/gnome-control-center[bluetooth] \
		net-wireless/gnome-bluetooth:3[introspection]
	optfeature "Browser extension integration" gnome-extra/gnome-browser-connector
	optfeature "Screencast/capture support" media-video/pipewire media-libs/gstreamer[introspection] \
		media-libs/gst-plugins-base[introspection] media-libs/gst-plugins-good media-plugins/gst-plugins-vpx
	optfeature "Weather support" dev-libs/libgweather:4[introspection]
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
