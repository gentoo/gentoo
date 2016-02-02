# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

CMAKE_MIN_VERSION="2.8"

inherit cmake-utils eutils git-r3

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="https://awesome.naquadah.org/"
EGIT_REPO_URI="git://github.com/${PN}WM/${PN}.git"
EGIT_BRANCH="3.5"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc elibc_FreeBSD gnome"

COMMON_DEPEND="
	>=dev-lang/lua-5.1:0
	>=dev-libs/libxdg-basedir-1
	>=dev-lua/lgi-0.7
	>=x11-libs/libxcb-1.6
	>=x11-libs/xcb-util-0.3.8
	>=x11-libs/xcb-util-keysyms-0.3.4
	>=x11-libs/xcb-util-wm-0.3.8
	dev-libs/glib:2
	x11-libs/cairo[xcb]
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
	x11-libs/pango[introspection]
	x11-libs/startup-notification
	x11-libs/xcb-util-cursor
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )"

# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
DEPEND="${COMMON_DEPEND}
	>=x11-proto/xproto-7.0.15
	app-text/asciidoc
	app-text/xmlto
	media-gfx/imagemagick[png]
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

RDEPEND="${COMMON_DEPEND}"

DOCS=( AUTHORS BUGS PATCHES README STYLE )

src_prepare() {
	# bug #408025
	epatch "${FILESDIR}/3.5/${PN}-3.5_rc1-convert-path.patch"

	# bug #507604
	epatch "${FILESDIR}/3.5/${PN}-3.5.5-util.lua-xdg-icons-fix.patch"
	# bug #509658
	epatch "${FILESDIR}/3.5/${PN}-3.5.5-cflag-cleanup.patch"

	# bug #571544
	# Merged upstream
	#epatch "${FILESDIR}/${PN}-3.5.6-fix-multi-instances-focus.patch"

	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}"/etc
		$(cmake-utils_use_with dbus DBUS)
		$(cmake-utils_use doc GENERATE_DOC)
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
			dohtml -r doxygen || die
		)
	fi
	rm -rf "${ED}"/usr/share/doc/${PN} || die "Cleanup of dupe docs failed"

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die

	# GNOME-based awesome
	if use gnome ; then
		# GNOME session
		insinto /usr/share/gnome-session/sessions
		newins "${FILESDIR}/${PN}-gnome-3.session" "${PN}-gnome.session" || die
		# Application launcher
		domenu "${FILESDIR}/${PN}-gnome.desktop" || die
		# X Session
		insinto /usr/share/xsessions/
		doins "${FILESDIR}/${PN}-gnome-xsession.desktop" || die
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
