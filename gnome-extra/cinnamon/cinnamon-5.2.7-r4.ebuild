# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )
PYTHON_REQ_USE="xml(+)"

inherit meson gnome2-utils pax-utils python-single-r1 xdg

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon"
SRC_URI="https://github.com/linuxmint/cinnamon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+eds +gstreamer gtk-doc +nls +networkmanager"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="amd64 ~arm64 ~riscv x86"

DEPEND="
	${PYTHON_DEPS}
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		( app-accessibility/at-spi2-atk dev-libs/atk )
	)
	>=dev-libs/glib-2.52.0:2[dbus]
	>=dev-libs/gobject-introspection-1.29.15:=
	dev-libs/libxml2:2
	>=gnome-extra/cinnamon-desktop-5.2:0=
	>=gnome-extra/cinnamon-menus-5.2
	>=gnome-extra/cjs-5.2[cairo]
	net-libs/libsoup:2.4[introspection]
	sys-apps/dbus
	>=sys-auth/polkit-0.100[introspection]
	virtual/opengl
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.12.0:3[introspection]
	>=x11-libs/libnotify-0.7.3:0=[introspection]
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0
	x11-libs/pango[introspection]
	>=x11-libs/startup-notification-0.11
	>=x11-wm/muffin-5.2[introspection]

	eds? (
		gnome-extra/evolution-data-server
	)
	gstreamer? (
		media-libs/gst-plugins-base:1.0
		media-libs/gstreamer:1.0
	)
	networkmanager? (
		net-misc/networkmanager[introspection]
	)
"
# caribou used by onscreen keyboard
# libtimezonemap used by datetime settings
# iso-flag-png (unpackaged) used by keyboard layout settings
RDEPEND="
	${DEPEND}
	>=app-accessibility/caribou-0.3
	dev-libs/keybinder:3[introspection]
	dev-libs/libtimezonemap
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyinotify[${PYTHON_USEDEP}]
		dev-python/python-pam[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/tinycss2[${PYTHON_USEDEP}]
		>=dev-python/python3-xapp-2.2.1-r1[${PYTHON_USEDEP}]
	')
	>=gnome-base/dconf-0.4.1
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	>=gnome-base/libgnomekbd-2.91.4
	>=gnome-extra/cinnamon-control-center-5.2[networkmanager=]
	>=gnome-extra/cinnamon-screensaver-5.2
	>=gnome-extra/cinnamon-session-5.2
	>=gnome-extra/cinnamon-settings-daemon-5.2
	>=gnome-extra/nemo-5.2
	gnome-extra/polkit-gnome
	net-misc/wget
	sys-apps/accountsservice[introspection]
	sys-power/upower[introspection]
	>=x11-libs/xapp-2.2.8[introspection]
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
	x11-themes/gnome-themes-standard

	nls? (
		>=gnome-extra/cinnamon-translations-5.2
	)
"
BDEPEND="
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig

	gtk-doc? ( dev-util/gtk-doc )
"

PATCHES=(
	# Fix backgrounds path as cinnamon doesn't provide them
	# https://github.com/linuxmint/Cinnamon/issues/3575
	"${FILESDIR}"/${PN}-3.8.0-gnome-background-compatibility.patch

	# Use wheel group instead of sudo (from Fedora/Arch)
	# https://github.com/linuxmint/Cinnamon/issues/3576
	"${FILESDIR}"/${PN}-3.6.6-wheel-sudo.patch

	# Make evolution-data-server integration optional
	"${FILESDIR}"/${PN}-5.2.7-eds-detection.patch

	# Meson fixes
	"${FILESDIR}"/${PN}-5.2.7-revert-meson-0.60-fix.patch
	"${FILESDIR}"/${PN}-5.2.7-meson-0.61-fix.patch
)

src_prepare() {
	xdg_src_prepare

	# Add polkit agent to required components
	# https://github.com/linuxmint/Cinnamon/issues/3579
	sed -i "s/'REQUIRED', '/&polkit-cinnamon-authentication-agent-1;/" meson.build || die

	# shebang fixing craziness
	local p
	for p in $(grep -rl '#!.*python3' || die); do
		python_fix_shebang "${p}"
	done
}

src_configure() {
	local emesonargs=(
		$(meson_use gstreamer build_recorder)
		$(meson_use gtk-doc docs)
		-Ddisable_networkmanager=$(usex networkmanager false true)
		-Dpy3modules_dir="$(python_get_sitedir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	python_optimize "${D}$(python_get_sitedir)"
	python_optimize "${ED}"/usr/share/cinnamon/

	# Required for gnome-shell on hardened/PaX, bug #398941
	pax-mark mr "${ED}"/usr/bin/cinnamon

	# Doesn't exist on Gentoo, causing this to be a dead symlink
	rm "${ED}/etc/xdg/menus/cinnamon-applications-merged" || die

	# Ensure authentication-agent is started, bug #523958
	# https://github.com/linuxmint/Cinnamon/issues/3579
	insinto /etc/xdg/autostart/
	doins "${FILESDIR}"/polkit-cinnamon-authentication-agent-1.desktop
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if use gstreamer; then
		if ! has_version 'media-libs/gst-plugins-good:1.0' || \
		   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
			ewarn "To make use of Cinnamon's built-in screen recording utility,"
			ewarn "you need to either install media-libs/gst-plugins-good:1.0"
			ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
			ewarn "org.cinnamon.recorder/pipeline to what you want to use."
		fi
	else
		ewarn "Cinnamon's built-in screen recording utility is not installed"
		ewarn "because gstreamer support is disabled."
	fi
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
