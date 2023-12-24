# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5"

inherit cmake xdg

DESCRIPTION="Fcitx 5 is a generic input method framework"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5"
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5/fcitx5-${PV}_dict.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2+ Unicode-DFS-2016"
SLOT="5"
KEYWORDS="~amd64 ~loong ~x86"
IUSE="+autostart doc +emoji +enchant +keyboard presage +server systemd test wayland +X"
REQUIRED_USE="
	|| ( wayland X )
	X? ( keyboard )
	wayland? ( keyboard )
"
RESTRICT="!test? ( test )"

RDEPEND="
	!app-i18n/fcitx:4
	dev-libs/libfmt
	sys-devel/gettext
	virtual/libintl
	x11-libs/cairo[X?]
	x11-libs/gdk-pixbuf:2
	x11-libs/pango[X?]
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-fontutils
	)
	emoji? ( sys-libs/zlib )
	enchant? ( app-text/enchant:2 )
	keyboard? (
		app-text/iso-codes
		dev-libs/expat
		dev-libs/json-c:=
		x11-misc/xkeyboard-config
		x11-libs/libxkbcommon[X?,wayland?]
	)
	systemd? (
		sys-apps/systemd
	)
	!systemd? (
		dev-libs/libevent
		sys-apps/dbus
	)
	wayland? (
		dev-libs/glib:2
		dev-libs/wayland
		dev-libs/wayland-protocols
		dev-util/wayland-scanner
	)
	X? (
		dev-libs/glib:2
		>=x11-libs/xcb-imdkit-1.0.3:5
		x11-libs/libX11
		x11-libs/libxkbfile
		x11-libs/xcb-util
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-wm
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	kde-frameworks/extra-cmake-modules:0
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DBUS=on
		-DENABLE_XDGAUTOSTART=$(usex autostart)
		-DENABLE_SERVER=$(usex server)
		-DENABLE_KEYBOARD=$(usex keyboard)
		-DENABLE_TEST=$(usex test)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_EMOJI=$(usex emoji)
		-DENABLE_PRESAGE=$(usex presage)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_X11=$(usex X)
		-DENABLE_DOC=$(usex doc)
		-DUSE_SYSTEMD=$(usex systemd)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}"/doc/*
}

src_test() {
	# break by sandbox
	local CMAKE_SKIP_TESTS=(
		testdbus
		testservicewatcher
	)
	cmake_src_test
}

pkg_postinst() {
	xdg_pkg_postinst

	elog
	elog "Follow the instrcutions on:"
	elog "https://wiki.gentoo.org/wiki/Fcitx#Using_Fcitx"
	elog "https://fcitx-im.org/wiki/Setup_Fcitx_5"
	elog "https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland"
	elog
}
