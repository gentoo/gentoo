# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3 pax-utils

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="https://awesomewm.org/"
EGIT_REPO_URI="https://github.com/awesomeWM/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus doc elibc_FreeBSD gnome luajit"

RDEPEND="
	>=dev-lang/lua-5.1:0
	dev-libs/glib:2
	>=dev-libs/libxdg-basedir-1
	>=dev-lua/lgi-0.7
	x11-libs/cairo[xcb]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libxcb-1.6
	>=x11-libs/pango-1.19.3[introspection]
	>=x11-libs/startup-notification-0.10_p20110426
	>=x11-libs/xcb-util-0.3.8
	x11-libs/xcb-util-cursor
	>=x11-libs/xcb-util-keysyms-0.3.4
	>=x11-libs/xcb-util-wm-0.3.8
	>=x11-libs/xcb-util-xrm-1.0
	x11-libs/libXcursor
	x11-libs/libxkbcommon[X]
	>=x11-libs/libX11-1.3.99.901
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )"

# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
DEPEND="${RDEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	dev-util/gperf
	virtual/pkgconfig
	media-gfx/imagemagick[png]
	>=x11-proto/xcb-proto-1.5
	>=x11-proto/xproto-7.0.15
	doc? ( dev-lua/ldoc )
	luajit? ( dev-lang/luajit:2 )"

DOCS=( docs/{00-authors,01-readme,02-contributing}.md )
PATCHES=(
	"${FILESDIR}/${PN}-4.0-convert-path.patch"  # bug #408025
	"${FILESDIR}/${PN}-xsession.patch"          # bug #408025
	"${FILESDIR}/${PN}-4.0-cflag-cleanup.patch" # bug #509658
)

src_configure() {
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DWITH_DBUS=$(usex dbus)
		-DWITH_GENERATE_DOC=$(usex doc $(usex doc) n)
	)
	if [ $(usex luajit) = "yes" ]; then
		mycmakeargs+=('-DLUA_INCLUDE_DIR=/usr/include/luajit-2.0')
		mycmakeargs+=('-DLUA_LIBRARY=/usr/lib/libluajit-5.1.so')
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	pax-mark m "${ED%/}"/usr/bin/awesome

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN}

	# GNOME-based awesome
	if use gnome; then
		# GNOME session
		insinto /usr/share/gnome-session/sessions
		newins "${FILESDIR}"/${PN}-gnome-3.session ${PN}-gnome.session

		# Application launcher
		domenu "${FILESDIR}"/${PN}-gnome.desktop

		# X Session
		insinto /usr/share/xsessions
		doins "${FILESDIR}"/${PN}-gnome-xsession.desktop
	fi
}

pkg_postinst() {
	# bug #447308
	if use gnome; then
		elog "You have enabled the gnome USE flag."
		elog "Please note that quitting awesome won't kill your gnome session."
		elog "To really quit the session, you should bind your quit key"
		elog "to the following command:"
		elog "  gnome-session-quit --logout"
		elog "For more info visit"
		elog "  https://bugs.gentoo.org/show_bug.cgi?id=447308"
	fi

	# bug #440724
	elog "If you are having issues with Java application windows being"
	elog "completely blank, try installing"
	elog "  x11-misc/wmname"
	elog "and setting the WM name to LG3D."
	elog "For more info visit"
	elog "  https://bugs.gentoo.org/show_bug.cgi?id=440724"
}
