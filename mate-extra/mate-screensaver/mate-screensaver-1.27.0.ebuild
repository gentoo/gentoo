# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mate readme.gentoo-r1

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
else
	KEYWORDS=""
fi

DESCRIPTION="Replaces xscreensaver, integrating with the MATE desktop"

LICENSE="GPL-2+ HPND LGPL-2+"
SLOT="0"
IUSE="X debug elogind libnotify opengl pam systemd"
REQUIRED_USE="?? ( elogind systemd )"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.71:0
	>=dev-libs/glib-2.58:2
	gnome-base/dconf
	>=mate-base/libmatekbd-1.17.0
	>=mate-base/mate-desktop-1.17.0
	>=mate-base/mate-menus-1.21.0
	>=sys-apps/dbus-0.30
	>=x11-libs/gdk-pixbuf-2.14:2
	>=x11-libs/libX11-1
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86vm
	x11-libs/libxklavier
	x11-libs/pango
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	opengl? ( virtual/opengl )
	pam? ( gnome-base/gnome-keyring sys-libs/pam )
	!pam? ( kernel_linux? ( sys-apps/shadow ) )
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd:= )
"

RDEPEND="${COMMON_DEPEND}
	>=mate-base/mate-session-manager-1.6
	virtual/libintl
	!!<gnome-extra/gnome-screensaver-3
	mate-base/mate-panel
"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxml2
	>=sys-devel/gettext-0.19.8:*
	x11-base/xorg-proto
	virtual/pkgconfig:*
"

DOC_CONTENTS="
	Information for converting screensavers is located in
	/usr/share/doc/${PF}/xss-conversion.txt*
"

src_configure() {
	local myconf=(
		--enable-locking
		--with-kbd-layout-indicator
		--with-xf86gamma-ext
		--with-xscreensaverdir=/usr/share/xscreensaver/config
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver
		--without-console-kit
		$(use_with X x)
		$(use_with elogind)
		$(use_with libnotify)
		$(use_with opengl libgl)
		$(use_with systemd)
		$(use_enable debug)
		$(use_enable pam)
	)

	mate_src_configure "${myconf[@]}"
}

src_install() {
	mate_src_install

	# Install the conversion script in the documentation.
	dodoc "${S}"/data/migrate-xscreensaver-config.sh
	dodoc "${S}"/data/xscreensaver-config.xsl
	dodoc "${FILESDIR}"/xss-conversion.txt

	# Non PAM users will need this suid to read the password hashes.
	# OpenPAM users will probably need this too when
	# https://bugzilla.gnome.org/show_bug.cgi?id=370847
	# is fixed.
	if ! use pam ; then
		fperms u+s /usr/libexec/mate-screensaver-dialog
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	mate_pkg_postinst

	if has_version "<x11-base/xorg-server-1.5.3-r4" ; then
		ewarn "You have a too old xorg-server installation. This will cause"
		ewarn "mate-screensaver to eat up your CPU. Please consider upgrading."
		echo
	fi

	if has_version "<x11-misc/xscreensaver-4.22-r2" ; then
		ewarn "You have xscreensaver installed, you probably want to disable it."
		ewarn "To prevent a duplicate screensaver entry in the menu, you need to"
		ewarn "build xscreensaver with -gnome in the USE flags."
		ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"
		echo
	fi

	readme.gentoo_print_elog
}
