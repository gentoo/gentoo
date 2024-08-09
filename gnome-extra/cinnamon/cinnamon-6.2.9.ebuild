# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="xml(+)"

inherit meson gnome2-utils pax-utils python-single-r1 xdg

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon"
SRC_URI="https://github.com/linuxmint/cinnamon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+ GPL-3+ GPL-3-with-openssl-exception LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+eds +gstreamer gtk-doc internal-polkit +nls +networkmanager wayland"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.52.0:2[dbus]
	>=dev-libs/gobject-introspection-1.29.15:=
	dev-libs/libxml2:2
	>=gnome-extra/cinnamon-desktop-6.2:0=
	>=gnome-extra/cinnamon-menus-6.2
	>=gnome-extra/cjs-6.2[cairo]
	sys-apps/dbus
	>=sys-auth/polkit-0.100[introspection]
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.12.0:3[introspection,wayland?]
	>=x11-libs/libnotify-0.7.3:0=[introspection]
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0
	x11-libs/pango[introspection]
	>=x11-libs/xapp-2.8.4[introspection]
	>=x11-wm/muffin-6.2[introspection,wayland?]

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
		>=dev-python/python3-xapp-2.4.2[${PYTHON_USEDEP}]
	')
	>=gnome-base/dconf-0.4.1
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	>=gnome-base/libgnomekbd-2.91.4
	>=gnome-extra/cinnamon-control-center-6.2[networkmanager=,wayland?]
	>=gnome-extra/cinnamon-screensaver-6.2
	>=gnome-extra/cinnamon-session-6.2
	>=gnome-extra/cinnamon-settings-daemon-6.2[wayland?]
	>=gnome-extra/nemo-6.2[wayland?]
	media-libs/gsound
	net-libs/libsoup:3.0[introspection]
	net-misc/wget
	sys-apps/accountsservice[introspection]
	sys-apps/coreutils
	sys-apps/pciutils
	sys-apps/util-linux
	sys-apps/xdg-desktop-portal-gtk
	sys-apps/xdg-desktop-portal-xapp
	sys-power/upower[introspection]
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
	x11-themes/gnome-themes-standard

	!internal-polkit? (
		gnome-extra/polkit-gnome
	)
	nls? (
		>=gnome-extra/cinnamon-translations-6.2
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
	"${FILESDIR}/${PN}-3.8.0-gnome-background-compatibility.patch"

	# Use wheel group instead of sudo (from Fedora/Arch)
	# https://github.com/linuxmint/Cinnamon/issues/3576
	"${FILESDIR}/${PN}-3.6.6-wheel-sudo.patch"

	# Make wayland optional
	# https://github.com/linuxmint/cinnamon/pull/12273
	"${FILESDIR}/${PN}-6.2.0-optional-wayland.patch"

	# Fix path for settings panels on arm64
	# https://github.com/linuxmint/cinnamon/pull/12278
	"${FILESDIR}/${PN}-6.2.0-fix-arm64-settings-panel-path.patch"
)

src_prepare() {
	if use internal-polkit; then
		PATCHES+=(
			# Use internal polkit agent on X11
			# https://github.com/linuxmint/cinnamon/pull/12272
			"${FILESDIR}/${PN}-6.2.0-polkit-agent-on-x11.patch"
		)
	else
		# Add polkit agent to required components
		# https://github.com/linuxmint/Cinnamon/issues/3579
		sed -i "s/'REQUIRED', '/&polkit-cinnamon-authentication-agent-1;/" meson.build || die
	fi

	default

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
		$(meson_use wayland)
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

	# Doesn't exist by default
	keepdir /etc/xdg/menus/applications-merged

	if ! use internal-polkit; then
		# Ensure authentication-agent is started, bug #523958
		# https://github.com/linuxmint/Cinnamon/issues/3579
		insinto /etc/xdg/autostart/
		doins "${FILESDIR}"/polkit-cinnamon-authentication-agent-1.desktop
	fi
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
