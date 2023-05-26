# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Drop in replacement for ueberzug written in C++"
HOMEPAGE="https://github.com/jstkdng/ueberzugpp/"
SRC_URI="https://github.com/jstkdng/ueberzugpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X opencv sway"

RDEPEND="
	dev-cpp/tbb:=
	dev-libs/glib:2
	dev-libs/libfmt:=
	dev-libs/openssl:=
	dev-libs/spdlog:=
	media-gfx/chafa
	media-libs/libsixel
	media-libs/vips:=
	sys-apps/util-linux
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-image
	)
	opencv? ( media-libs/opencv:= )
	sway? ( dev-libs/wayland )
	!media-gfx/ueberzug"
DEPEND="
	${RDEPEND}
	dev-cpp/cli11
	dev-cpp/ms-gsl
	dev-cpp/nlohmann_json
	X? ( x11-base/xorg-proto )
	sway? ( dev-libs/wayland-protocols )"
BDEPEND="
	sway? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)"

src_configure() {
	CMAKE_BUILD_TYPE=Release # install target wants this

	local mycmakeargs=(
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_SWAY=$(usex sway)
		-DENABLE_TURBOBASE64=no # not packaged
		-DENABLE_X11=$(usex X)
		-DFETCHCONTENT_FULLY_DISCONNECTED=yes
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# not handled by cmake, but upstream creates the pp symlink in their
	# self-maintained AUR package and some scripts like ytfzf look for it
	dosym ueberzug /usr/bin/${PN}
}
