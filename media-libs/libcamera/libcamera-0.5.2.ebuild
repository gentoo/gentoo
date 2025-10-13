# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-single-r1

DESCRIPTION="An open source camera stack and framework for Linux, Android, and ChromeOS"
HOMEPAGE="https://libcamera.org"
SRC_URI="https://gitlab.freedesktop.org/camera/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="Apache-2.0 CC0-1.0 BSD-2 CC-BY-4.0 CC-BY-SA-4.0 GPL-2+ GPL-2 LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X debug gstreamer qt6 test udev v4l"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/jinja2
		dev-python/ply
		dev-python/pyyaml
	')
	dev-libs/libyaml
	dev-libs/openssl:=
	media-libs/libyuv
	media-libs/tiff:=
	net-libs/gnutls
	virtual/libelf:=
	debug? ( dev-util/lttng-ust )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	test? (
		qt6? (
			dev-qt/qtbase:6[gui,opengl,widgets]
			dev-qt/qttools:6[linguist]
		)
		X? (
			media-libs/libjpeg-turbo:=
			media-libs/libsdl2
			x11-libs/libdrm
		)
		dev-cpp/gtest
		dev-libs/libevent
	)
	udev? ( virtual/libudev:= )
	v4l? ( media-libs/libv4l )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature v4l v4l2)
		-Dpycamera=disabled # experimental python bindings
		$(meson_feature gstreamer)
		$(meson_feature test lc-compliance)
		$(meson_feature test qcam)
		$(meson_feature debug tracing)
		$(meson_feature udev)
		$(meson_feature test cam)
		-Dtest=$(usex test true false)
		-Ddocumentation=disabled
	)
	meson_src_configure
}
