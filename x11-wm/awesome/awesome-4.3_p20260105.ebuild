# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
inherit cmake desktop lua-single pax-utils

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/awesomeWM/${PN}.git"
else
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
	if [[ ${PV} == *_p* ]] ; then
		HASH_COMMIT="cab3e81dc6071e3c1c4bd15cf8fab91236c7f2bd"
		SRC_URI="https://github.com/awesomeWM/awesome/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${HASH_COMMIT}"
	else
		SRC_URI="https://github.com/awesomeWM/awesome-releases/raw/master/${P}.tar.xz"
	fi
fi

DESCRIPTION="Dynamic floating and tiling window manager"
HOMEPAGE="https://awesomewm.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus doc gnome test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# Doesn't play nicely with the sandbox + requires an active D-BUS session
RESTRICT="test"

RDEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.79.2:2
	dev-libs/libxdg-basedir
	$(lua_gen_cond_dep 'dev-lua/lgi[${LUA_USEDEP}]')
	gnome-base/librsvg[introspection]
	x11-libs/cairo[X,xcb(+)]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/libxcb:=
	x11-libs/pango[introspection]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	x11-libs/libxkbcommon[X]
	x11-libs/libX11
	dbus? ( sys-apps/dbus )
"
DEPEND="
	${RDEPEND}
	x11-base/xcb-proto
	x11-base/xorg-proto
	test? (
		x11-base/xorg-server[xvfb]
		$(lua_gen_cond_dep '
			dev-lua/busted[${LUA_USEDEP}]
			dev-lua/luacheck[${LUA_USEDEP}]
		')
	)
"
# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
BDEPEND="
	media-gfx/imagemagick[png]
	virtual/pkgconfig
	doc? (
		dev-lua/ldoc
		dev-ruby/asciidoctor
	)
	test? (
		app-shells/zsh
		x11-apps/xeyes
	)
"

# Skip installation of README.md by einstalldocs, which leads to broken symlink
DOCS=()

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-convert-path.patch  # bug #408025
	"${FILESDIR}"/${PN}-xsession.patch          # bug #408025
	"${FILESDIR}"/${PN}-4.3-cflag-cleanup.patch # bug #509658
	"${FILESDIR}"/${PN}-4.3_p20260105-bump_cmake_min.patch
)

src_prepare() {
	cmake_src_prepare
	if ! use doc; then
		cp "${FILESDIR}"/awesome{.1,-client.1,rc.5} "${S}"/manpages/ || die
	fi
}

src_configure() {
	# Compression of manpages is handled by portage.
	# AutoOption.cmake requires ON, OFF or AUTO
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}"/etc
		-DCOMPRESS_MANPAGES=OFF
		-DWITH_DBUS=$(usex dbus ON OFF)
		-DGENERATE_DOC=$(usex doc)
		-DGENERATE_MANPAGES=$(usex doc ON OFF)
		-DAWESOME_DOC_PATH="${EPREFIX}"/usr/share/doc/${PF}
		-DLUA_INCLUDE_DIR="$(lua_get_include_dir)"
		-DLUA_LIBRARY="$(lua_get_shared_lib)"
	)

	[[ ${PV} != *9999* ]] && mycmakeargs+=( -DOVERRIDE_VERSION="v${PV}" )

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

	# use html subdir and precompiled manpages w/o doc enabled
	if use doc; then
		mv "${ED}"/usr/share/doc/${PF}/{doc,html} || die
	else
		doman "${S}"/manpages/awesome{.1,rc.5}
		use dbus && doman "${S}"/manpages/awesome-client.1
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
}
