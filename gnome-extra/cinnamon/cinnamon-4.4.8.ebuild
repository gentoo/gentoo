# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="xml"

inherit autotools eutils flag-o-matic gnome2 multilib pax-utils python-single-r1

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"

MY_PV="${PV/_p/-UP}"
MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/linuxmint/cinnamon/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

IUSE="gtk-doc +nls +networkmanager"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="${PYTHON_DEPS}
	app-accessibility/at-spi2-atk:2
	app-misc/ca-certificates
	dev-libs/dbus-glib
	>=dev-libs/glib-2.35.0:2[dbus]
	>=dev-libs/gobject-introspection-1.29.15:=
	>=dev-libs/libcroco-0.6.2:0.6
	dev-libs/libxml2:2
	>=gnome-extra/cinnamon-desktop-4.4:0=
	>=gnome-extra/cinnamon-menus-4.4
	>=gnome-extra/cjs-4.4.0[cairo]
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	net-libs/libsoup:2.4[introspection]
	>=sys-auth/polkit-0.100[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.12.0:3[introspection]
	x11-libs/pango[introspection]
	>=x11-libs/startup-notification-0.11
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0
	>=x11-wm/muffin-4.0.3[introspection]
	dev-libs/keybinder:3[introspection]
	>=x11-libs/libnotify-0.7.3:0=[introspection]
"
# Runtime-only deps are probably incomplete and approximate.
# Each block:
# 2. Introspection stuff + dconf needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. accountsservice is needed for GdmUserManager (0.6.14 needed for fast
#    user switching with gdm-3.1.x)
# 6. caribou needed for on-screen keyboard
# 7. xdg-utils needed for xdg-open, used by extension tool
# 8. imaging, lxml needed for cinnamon-settings
# 9. gnome-icon-theme-symbolic needed for various icons
# 10. pygobject needed for menu editor
# 11. nemo - default file manager, tightly integrated with cinnamon
# 12. polkit-gnome - explicitly autostarted by us
# TODO(lxnay): fix error: libgnome-desktop/gnome-rr-labeler.h: No such file or directory
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/dconf-0.4.1
	>=gnome-base/libgnomekbd-2.91.4
	sys-power/upower[introspection]

	>=gnome-extra/cinnamon-session-4.4
	>=gnome-extra/cinnamon-settings-daemon-4.4

	>=app-accessibility/caribou-0.3

	dev-libs/libtimezonemap
	x11-misc/xdg-utils
	x11-libs/xapps[introspection]

	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pyinotify[${PYTHON_USEDEP}]
		dev-python/pypam[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/tinycss[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/xapp[${PYTHON_USEDEP}]
	')

	x11-themes/gnome-themes-standard
	x11-themes/adwaita-icon-theme

	>=gnome-extra/nemo-4.4
	>=gnome-extra/cinnamon-control-center-4.4[networkmanager=]
	>=gnome-extra/cinnamon-screensaver-4.4

	gnome-extra/polkit-gnome

	nls? ( >=gnome-extra/cinnamon-translations-4.4 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	!!=dev-lang/spidermonkey-1.8.2*
	gtk-doc? ( dev-util/gtk-doc )
"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/show_bug.cgi?id=360413

src_prepare() {
	# Fix backgrounds path as cinnamon doesn't provide them
	# https://github.com/linuxmint/Cinnamon/issues/3575
	eapply "${FILESDIR}"/${PN}-3.8.0-gnome-background-compatibility.patch

	# Use wheel group instead of sudo (from Fedora/Arch)
	# https://github.com/linuxmint/Cinnamon/issues/3576
	eapply "${FILESDIR}"/${PN}-3.6.6-wheel-sudo.patch

	# Add polkit agent to required components (from Fedora/Arch), bug #523958
	# https://github.com/linuxmint/Cinnamon/issues/3579
	sed -i 's/RequiredComponents=\(.*\)$/RequiredComponents=\1polkit-gnome-authentication-agent-1;/' \
		files/cinnamon*.session.in || die

	# shebang fixing craziness
	local p
	for p in $(grep -rl '#!.*python3'); do
		python_fix_shebang "${p}"
	done

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-ca-certificates="${EPREFIX}/etc/ssl/certs/ca-certificates.crt" \
		$(use_enable gtk-doc) \
		$(use_enable networkmanager) \
		BROWSER_PLUGIN_DIR="${EPREFIX}/usr/$(get_libdir)/nsbrowser/plugins"
}

src_install() {
	gnome2_src_install
	python_optimize "${ED}"usr/share/cinnamon/

	# Required for gnome-shell on hardened/PaX, bug #398941
	pax-mark mr "${ED}usr/bin/cinnamon"

	# Doesn't exist on Gentoo, causing this to be a dead symlink
	rm -f "${ED}etc/xdg/menus/cinnamon-applications-merged" || die

	# Ensure authentication-agent is started, bug #523958
	# https://github.com/linuxmint/Cinnamon/issues/3579
	insinto /etc/xdg/autostart/
	doins "${FILESDIR}"/polkit-cinnamon-authentication-agent-1.desktop
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of Cinnamon's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "org.cinnamon.recorder/pipeline to what you want to use."
	fi
}
