# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake desktop lua-single pax-utils

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/awesomeWM/${PN}.git"
else
	SRC_URI="https://github.com/awesomeWM/awesome-releases/raw/master/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="https://awesomewm.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus doc gnome test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RESTRICT="test" # https://bugs.gentoo.org/654084

RDEPEND="${LUA_DEPS}
	dev-libs/glib:2
	dev-libs/libxdg-basedir
	$(lua_gen_cond_dep 'dev-lua/lgi[${LUA_USEDEP}]')
	x11-libs/cairo[X,xcb(+)]
	x11-libs/gdk-pixbuf:2
	x11-libs/libxcb[xkb]
	x11-libs/pango[introspection]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	x11-libs/libXcursor
	x11-libs/libxkbcommon[X]
	x11-libs/libX11
	dbus? ( sys-apps/dbus )"
# ldoc is used by invoking its executable, hence no need for LUA_SINGLE_USEDEP.
# On the other hand, it means that we should explicitly depend on a version
# migrated to Lua eclasses so that during the upgrade from unslotted
# to slotted dev-lang/lua, the package manager knows to emerge migrated
# ldoc before migrated awesome.
DEPEND="${RDEPEND}
	x11-base/xcb-proto
	x11-base/xorg-proto
	test? (
		x11-base/xorg-server[xvfb]
		$(lua_gen_cond_dep '
			dev-lua/busted[${LUA_USEDEP}]
			dev-lua/luacheck[${LUA_USEDEP}]
		')
	)"
# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
BDEPEND="app-text/asciidoc
	media-gfx/imagemagick[png]
	virtual/pkgconfig
	doc? ( >=dev-lua/ldoc-1.4.6-r100 )
	test? ( app-shells/zsh )"

# Skip installation of README.md by einstalldocs, which leads to broken symlink
DOCS=()

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-convert-path.patch  # bug #408025
	"${FILESDIR}"/${PN}-xsession.patch          # bug #408025
	"${FILESDIR}"/${PN}-4.0-cflag-cleanup.patch # bug #509658
)

src_configure() {
	# Compression of manpages is handled by portage.
	# WITH_DBUS uses AutoOption.cmake which currently does not
	# understand yes/no (or indeed any values other than ON, OFF
	# or AUTO).
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DCOMPRESS_MANPAGES=OFF
		-DWITH_DBUS=$(usex dbus ON OFF)
		-DGENERATE_DOC=$(usex doc)
		-DAWESOME_DOC_PATH="${EPREFIX}"/usr/share/doc/${PF}
		-DLUA_INCLUDE_DIR="$(lua_get_include_dir)"
		-DLUA_LIBRARY="$(lua_get_shared_lib)"
	)
	cmake_src_configure
}

src_test() {
	# awesome's test suite starts Xvfb by itself, no need for virtualx eclass
	HEADLESS=1 cmake_build check -j1
}

src_install() {
	cmake_src_install
	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die

	pax-mark m "${ED}"/usr/bin/awesome

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

	# This directory contains SVG images which we don't want to compress
	use doc && docompress -x /usr/share/doc/${PF}/doc
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
