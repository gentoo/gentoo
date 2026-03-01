# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# dev-python/pyinotify doesn't have py3.14 yet
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="xml(+)"

inherit meson gnome2-utils optfeature pax-utils python-single-r1 xdg

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon"
SRC_URI="https://github.com/linuxmint/cinnamon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+ GPL-3+ GPL-3-with-openssl-exception LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="+eds +gstreamer gtk-doc +nls +networkmanager wayland"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=app-crypt/gcr-3.7.5:0/1
	>=dev-libs/glib-2.79.2:2[dbus]
	>=dev-libs/gobject-introspection-1.82.0-r2:=
	dev-libs/libxml2:2=
	>=gnome-extra/cinnamon-desktop-6.6:0=
	>=gnome-extra/cinnamon-menus-6.6
	>=gnome-extra/cjs-128[cairo(+)]
	sys-apps/dbus
	>=sys-auth/polkit-0.100[introspection]
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.12.0:3[introspection,wayland?,X]
	>=x11-libs/libnotify-0.7.3:0=[introspection]
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0
	x11-libs/pango[introspection]
	>=x11-libs/xapp-3.2.2[introspection]
	>=x11-wm/muffin-6.6[introspection,wayland?]

	eds? (
		gnome-extra/evolution-data-server
	)
	gstreamer? (
		media-libs/gst-plugins-base:1.0
		media-libs/gstreamer:1.0
	)
	networkmanager? (
		>=app-crypt/libsecret-0.18
		>=net-misc/networkmanager-1.10.4[introspection]
	)
"
# libtimezonemap used by datetime settings
# iso-flag-png (unpackaged) used by keyboard layout settings
RDEPEND="
	${DEPEND}
	app-i18n/ibus[introspection]
	dev-libs/keybinder:3[introspection]
	dev-libs/libtimezonemap
	$(python_gen_cond_dep '
		dev-python/babel[${PYTHON_USEDEP}]
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
		>=dev-python/python3-xapp-3.0.2[${PYTHON_USEDEP}]
	')
	>=gnome-base/dconf-0.4.1
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	>=gnome-base/libgnomekbd-2.91.4
	>=gnome-extra/cinnamon-control-center-6.6[networkmanager=,wayland?]
	>=gnome-extra/cinnamon-screensaver-6.6
	>=gnome-extra/cinnamon-session-6.6
	>=gnome-extra/cinnamon-settings-daemon-6.6[wayland?]
	>=gnome-extra/nemo-6.6[wayland?]
	media-libs/graphene[introspection]
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
	x11-themes/xapp-symbolic-icon-theme

	nls? (
		>=gnome-extra/cinnamon-translations-6.6
	)
"
BDEPEND="
	dev-lang/sassc
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
)

src_prepare() {
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
		-Dnm_agent=$(usex networkmanager internal disabled)
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

	optfeature "Thunderbolt security management in System Settings" sys-apps/bolt
	optfeature "additional hardware information in System Settings" sys-apps/inxi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
