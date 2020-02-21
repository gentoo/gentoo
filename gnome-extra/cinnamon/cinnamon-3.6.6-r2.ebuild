# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE="xml"

inherit autotools eutils flag-o-matic gnome2 multilib pax-utils python-r1

DESCRIPTION="A fork of GNOME Shell with layout similar to GNOME 2"
HOMEPAGE="http://developer.linuxmint.com/projects/cinnamon-projects.html"

MY_PV="${PV/_p/-UP}"
MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/linuxmint/Cinnamon/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

# bluetooth support dropped due to bug #511648
IUSE="+nls +networkmanager" #+bluetooth

# We need *both* python 2.x and 3.x
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( $(python_gen_useflags 'python2*') )
	|| ( $(python_gen_useflags 'python3*') )
"

KEYWORDS="amd64 x86"

COMMON_DEPEND="${PYTHON_DEPS}
	app-accessibility/at-spi2-atk:2
	app-misc/ca-certificates
	dev-libs/dbus-glib
	>=dev-libs/glib-2.35.0:2[dbus]
	>=dev-libs/gobject-introspection-0.10.1:=
	>=dev-libs/json-glib-0.13.2
	>=dev-libs/libcroco-0.6.2:0.6
	dev-libs/libxml2:2
	gnome-base/gconf:2[introspection]
	gnome-base/librsvg
	>=gnome-extra/cinnamon-desktop-3.6:0=[introspection]
	>=gnome-extra/cinnamon-menus-3.6[introspection]
	>=gnome-extra/cjs-3.6.0
	>=media-libs/clutter-1.10:1.0[introspection]
	media-libs/cogl:1.0=[introspection]
	>=gnome-base/gsettings-desktop-schemas-2.91.91
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	net-libs/libsoup:2.4[introspection]
	>=sys-auth/polkit-0.100[introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=x11-libs/gtk+-3.9.12:3[introspection]
	x11-libs/pango[introspection]
	>=x11-libs/startup-notification-0.11
	x11-libs/libX11
	>=x11-libs/libXfixes-5.0
	>=x11-wm/muffin-3.6.0[introspection]
	networkmanager? (
		gnome-base/libgnome-keyring
		>=net-misc/networkmanager-0.8.999:=[introspection] )
"
#bluetooth? ( >=net-wireless/gnome-bluetooth-3.1:=[introspection] )

# Runtime-only deps are probably incomplete and approximate.
# Each block:
# 2. Introspection stuff + dconf needed via imports.gi.*
# 3. gnome-session is needed for gnome-session-quit
# 4. Control shell settings
# 5. accountsservice is needed for GdmUserManager (0.6.14 needed for fast
#    user switching with gdm-3.1.x)
# 6. caribou needed for on-screen keyboard
# 7. xdg-utils needed for xdg-open, used by extension tool
# 8. gconf-python, imaging, lxml needed for cinnamon-settings
# 9. gnome-icon-theme-symbolic needed for various icons
# 10. pygobject needed for menu editor
# 11. nemo - default file manager, tightly integrated with cinnamon
# 12. polkit-gnome - explicitly autostarted by us
# TODO(lxnay): fix error: libgnome-desktop/gnome-rr-labeler.h: No such file or directory
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/dconf-0.4.1
	>=gnome-base/libgnomekbd-2.91.4[introspection]
	sys-power/upower[introspection]

	>=gnome-extra/cinnamon-session-3.6
	>=gnome-extra/cinnamon-settings-daemon-3.6

	>=app-accessibility/caribou-0.3

	x11-misc/xdg-utils
	x11-libs/xapps[introspection]

	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/gconf-python:2[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/lxml[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/pexpect[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/pycairo[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/pyinotify[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/pypam[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/pillow[${PYTHON_USEDEP}]' 'python2*')

	x11-themes/gnome-themes-standard
	x11-themes/adwaita-icon-theme

	>=gnome-extra/nemo-3.6
	>=gnome-extra/cinnamon-control-center-3.6
	>=gnome-extra/cinnamon-screensaver-3.6

	gnome-extra/polkit-gnome

	networkmanager? (
		gnome-extra/nm-applet
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	nls? ( >=gnome-extra/cinnamon-translations-2.4 )
"
#bluetooth? ( net-wireless/cinnamon-bluetooth )

DEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep 'dev-python/polib[${PYTHON_USEDEP}]' 'python2*')
	dev-util/gtk-doc
	>=dev-util/intltool-0.4
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	gnome-base/gnome-common
	!!=dev-lang/spidermonkey-1.8.2*
"
# libmozjs.so is picked up from /usr/lib while compiling, so block at build-time
# https://bugs.gentoo.org/show_bug.cgi?id=360413

S="${WORKDIR}/Cinnamon-${PV}"

pkg_setup() {
	python_setup
}

src_prepare() {
	# Fix backgrounds path as cinnamon doesn't provide them
	# https://github.com/linuxmint/Cinnamon/issues/3575
	eapply "${FILESDIR}"/${PN}-2.8.0-background.patch

	# Fix automagic gnome-bluetooth dep, bug #398145
	eapply "${FILESDIR}"/${PN}-2.2.6-automagic-gnome-bluetooth.patch

	# Use wheel group instead of sudo (from Fedora/Arch)
	# https://github.com/linuxmint/Cinnamon/issues/3576
	eapply "${FILESDIR}"/${PN}-3.6.6-wheel-sudo.patch

	# Use pkexec instead of gksu (from Arch)
	# https://github.com/linuxmint/Cinnamon/issues/3565
	sed -i 's/gksu/pkexec/' files/usr/bin/cinnamon-settings-users || die

	# Add polkit agent to required components (from Fedora/Arch), bug #523958
	# https://github.com/linuxmint/Cinnamon/issues/3579
	sed -i 's/RequiredComponents=\(.*\)$/RequiredComponents=\1polkit-gnome-authentication-agent-1;/' \
		files/usr/share/cinnamon-session/sessions/cinnamon*.session || die

	if ! use networkmanager; then
		rm -rv files/usr/share/cinnamon/applets/network@cinnamon.org || die
	fi

	# python 2-and-3 shebang fixing craziness
	local p
	python_setup 'python3*'
	for p in $(grep -rl '#!.*python3'); do
		python_fix_shebang "${p}"
	done

	python_setup 'python2*'
	for p in $(grep -rl '#!.*python[^3]'); do
		python_fix_shebang "${p}"
	done

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--disable-jhbuild-wrapper-script \
		$(use_enable networkmanager) \
		--with-ca-certificates="${EPREFIX}/etc/ssl/certs/ca-certificates.crt" \
		BROWSER_PLUGIN_DIR="${EPREFIX}/usr/$(get_libdir)/nsbrowser/plugins" \
		--without-bluetooth
}

src_install() {
	gnome2_src_install
	python_optimize "${ED}"usr/$(get_libdir)/cinnamon-*

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

	if ! has_version ">=x11-base/xorg-server-1.11"; then
		ewarn "If you use multiple screens, it is highly recommended that you"
		ewarn "upgrade to >=x11-base/xorg-server-1.11 to be able to make use of"
		ewarn "pointer barriers which will make it easier to use hot corners."
	fi

	if has_version "<x11-drivers/ati-drivers-12"; then
		ewarn "Cinnamon has been reported to show graphical corruption under"
		ewarn "x11-drivers/ati-drivers-11.*; you may want to switch to"
		ewarn "open-source drivers."
	fi
}
