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
IUSE="X opencv wayland"

RDEPEND="
	dev-cpp/tbb:=
	dev-libs/glib:2
	dev-libs/libfmt:=
	dev-libs/openssl:=
	dev-libs/spdlog:=
	media-gfx/chafa
	media-libs/libsixel
	media-libs/vips:=
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-image
	)
	opencv? ( media-libs/opencv:= )
	wayland? ( dev-libs/wayland )
	!media-gfx/ueberzug"
DEPEND="
	${RDEPEND}
	dev-cpp/cli11
	dev-cpp/ms-gsl
	dev-cpp/nlohmann_json
	X? ( x11-base/xorg-proto )
	wayland? ( dev-libs/wayland-protocols )"
BDEPEND="
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)"

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_TURBOBASE64=no # not packaged
		-DENABLE_WLROOTS=$(usex wayland)
		-DENABLE_X11=$(usex X)
		-DFETCHCONTENT_FULLY_DISCONNECTED=yes
	)

	cmake_src_configure
}

src_install() {
	# cmake install target is basic (misses the man page and symlinks) and
	# is gated behind CMAKE_BUILD_TYPE, simpler to do manual for now
	dobin "${BUILD_DIR}"/ueberzug
	dosym ueberzug /usr/bin/${PN}

	doman docs/${PN}.1
	dosym ${PN}.1 /usr/share/man/man1/ueberzug.1

	einstalldocs
}
