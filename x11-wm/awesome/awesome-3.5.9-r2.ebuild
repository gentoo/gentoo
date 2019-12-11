# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
inherit cmake-utils eutils

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
SRC_URI="http://awesome.naquadah.org/download/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="dbus doc elibc_FreeBSD gnome"

COMMON_DEPEND="
	|| ( >=dev-lang/lua-5.1:0 dev-lang/lua:5.1 )
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
	x11-libs/libXcursor
	>=x11-libs/libX11-1.3.99.901
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( || ( dev-libs/libexecinfo >=sys-freebsd/freebsd-lib-10.0 ) )"

# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
DEPEND="${COMMON_DEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	dev-util/gperf
	virtual/pkgconfig
	media-gfx/imagemagick[png]
	>=x11-base/xcb-proto-1.5
	x11-base/xorg-proto
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

RDEPEND="${COMMON_DEPEND}"

DOCS="AUTHORS BUGS PATCHES README STYLE"

PATCHES=(
	"${FILESDIR}/${PN}-3.5_rc1-convert-path.patch"
	"${FILESDIR}/${PN}-xsession.patch"
	"${FILESDIR}/${PN}-3.5.5-util.lua-xdg-icons-fix.patch"
	"${FILESDIR}/${PN}-3.5.5-cflag-cleanup.patch"
	"${FILESDIR}/${PN}-3.5.9-slotted-lua.patch"
)

src_configure() {
	has_version 'dev-lang/lua:5.1' \
		&& LUA=lua5.1 \
		|| LUA=lua
	mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}"/etc
		$(cmake-utils_use_with dbus DBUS)
		$(cmake-utils_use doc GENERATE_DOC)
		-DLUA_EXECUTABLE="${EPREFIX}"/usr/bin/${LUA}
		)

	cmake-utils_src_configure
}

src_compile() {
	local myargs="all"

	if use doc ; then
		myargs="${myargs} doc"
	fi
	cmake-utils_src_make ${myargs}
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		(
			cd "${CMAKE_BUILD_DIR}"/doc
			mv html doxygen
			dohtml -r doxygen
		)
	fi
	rm -rf "${ED}"/usr/share/doc/${PN} || die "Cleanup of dupe docs failed"

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die

	# GNOME-based awesome
	if use gnome ; then
		# GNOME session
		insinto /usr/share/gnome-session/sessions
		newins "${FILESDIR}/${PN}-gnome-3.session" "${PN}-gnome.session"
		# Application launcher
		domenu "${FILESDIR}/${PN}-gnome.desktop" || die
		# X Session
		insinto /usr/share/xsessions/
		doins "${FILESDIR}/${PN}-gnome-xsession.desktop"
	fi
}

pkg_postinst() {
	# bug #447308
	if use gnome; then
		elog
		elog "You have enabled the gnome USE flag."
		elog "Please note that quitting awesome won't kill your gnome session."
		elog "To really quit the session, you should bind your quit key"
		elog "to the following command:"
		elog "  gnome-session-quit --logout"
		elog "For more info visit"
		elog "  https://bugs.gentoo.org/show_bug.cgi?id=447308"
	fi

	# bug #440724
	elog
	elog "If you are having issues with Java application windows being"
	elog "completely blank, try installing"
	elog "  x11-misc/wmname"
	elog "and setting the WM name to LG3D."
	elog "For more info visit"
	elog "  https://bugs.gentoo.org/show_bug.cgi?id=440724"
	elog
}
