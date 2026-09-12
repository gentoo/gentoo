# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg-utils

MY_P=ChiPass-${PV}
DESCRIPTION="A slop-free, Qt6 secure password manager"
HOMEPAGE="https://codeberg.org/ChiPass/ChiPass"
SRC_URI="https://codeberg.org/ChiPass/ChiPass/releases/download/v${PV}/${MY_P}-source.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="|| ( GPL-2 GPL-3 )"
# icons, see COPYING
LICENSE+=" LGPL-2 MIT CC0-1.0 Apache-2.0 GPL-2+"
# QTIOCompressor
LICENSE+=" || ( LGPL-2.1 GPL-3 )"
# zxcvb (TODO: unbundle)
LICENSE+=" MIT"
# KMessageWidget
LICENSE+=" LGPL-2.1"
# ykcore
LICENSE+=" BSD-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE="X test yubikey"
RESTRICT="!test? ( test )"

DEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	dev-libs/zxcvbn-c
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl]
	dev-qt/qtsvg:6
	media-gfx/qrencode:=
	sys-libs/readline:=
	virtual/minizip:=
	virtual/zlib:=
	yubikey? (
		sys-apps/pcsc-lite
		virtual/libusb:1
	)
	X? (
		x11-libs/libX11
		x11-libs/libXtst
	)
"
RDEPEND="${DEPEND}"
# asciidoctor is needed to build manpages
BDEPEND="
	dev-libs/appstream
	dev-qt/qttools:6[linguist]
	dev-ruby/asciidoctor
	virtual/pkgconfig
	test? (
		x11-misc/xclip
	)
"

src_unpack() {
	# https://codeberg.org/ChiPass/ChiPass/issues/120
	mkdir "${S}" || die
	cd "${S}" || die
	default
}

src_prepare() {
	cmake_src_prepare

	# unbundle zxcvbn-c
	# it goes via add_library(zxcvbn), so CMake will just pass -lzxcvbn
	# if it's not defined
	> vendor/zxcvbn/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCHIPASS_WITH_AUTOTYPE=$(usex X)
		-DCHIPASS_WITH_YUBIKEY=$(usex yubikey)
		# Wayland support has no dependencies
		-DCHIPASS_DESKTOP_TYPES=$(usev X "X11;")Wayland
		-DCHIPASS_WITH_UPDATE_CHECK=OFF
		# manpages + a few docs
		-DCHIPASS_WITH_MANUAL=ON
		-DCHIPASS_WITH_TESTS=$(usex test)
		# GUI tests are very flaky, also on a real X11 session
		-DCHIPASS_WITH_GUI_TESTS=OFF
	)

	cmake_src_configure
}

src_test() {
	# we need xvfb for clipboard
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	# https://codeberg.org/ChiPass/ChiPass/issues/122
	mv "${ED}"/usr/share/{ChiPass/,}/man || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
