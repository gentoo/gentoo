# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="Drop in replacement for ueberzug written in C++"
HOMEPAGE="https://github.com/jstkdng/ueberzugpp/"
SRC_URI="
	https://github.com/jstkdng/ueberzugpp/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="X dbus opencv opengl wayland xcb-errors"
REQUIRED_USE="xcb-errors? ( X )"

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
		xcb-errors? ( x11-libs/xcb-util-errors )
	)
	dbus? ( sys-apps/dbus )
	opencv? ( media-libs/opencv:= )
	opengl? ( media-libs/libglvnd )
	wayland? ( dev-libs/wayland )
	!media-gfx/ueberzug
"
DEPEND="
	${RDEPEND}
	dev-cpp/cli11
	dev-cpp/nlohmann_json
	dev-cpp/range-v3
	X? ( x11-base/xorg-proto )
	wayland? ( dev-libs/wayland-protocols )
"
BDEPEND="
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

src_configure() {
	if use X && tc-is-clang && has_version sys-libs/libcxx; then
		# X support makes use of C++20's std::jthread which is currently
		# marked experimental (at least) in <=libcxx-18 (should limit
		# version in above libcxx check whenever this becomes unnecessary)
		append-cxxflags $(test-flags-CXX -fexperimental-library)
	fi

	# TODO?: wayfire plugin is skipped for now (needs wlroots which is
	# likely to be messier), but could be handled if there is a demand

	local mycmakeargs=(
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_TURBOBASE64=no # not packaged
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_X11=$(usex X)
		-DENABLE_XCB_ERRORS=$(usex xcb-errors)
		-DFETCHCONTENT_FULLY_DISCONNECTED=yes
	)

	cmake_src_configure
}
