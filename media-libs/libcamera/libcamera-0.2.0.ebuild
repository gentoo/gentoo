# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A complex camera support library for Linux, Android, and ChromeOS"
HOMEPAGE="https://libcamera.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.libcamera.org/libcamera/libcamera.git"
else
	SRC_URI="https://github.com/kbingham/libcamera/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

#IUSE="debug doc drm gnutls gstreamer jpeg libevent qt5 sdl tiff trace udev unwind v4l2"
IUSE="debug drm gnutls gstreamer jpeg libevent qt5 sdl tiff trace udev unwind v4l2"
REQUIRED_USE="qt5? ( tiff )"

DEPEND="
	dev-libs/libyaml:=
	dev-python/jinja
	dev-python/ply
	dev-python/pyyaml
	|| (
		net-libs/gnutls
		dev-libs/openssl
	)
	debug? ( dev-libs/elfutils:= )
	gstreamer? ( media-libs/gstreamer:= )
	libevent?
	(
		dev-libs/libevent:=
		drm? ( x11-libs/libdrm:= )
		jpeg? ( media-libs/libjpeg-turbo:= )
		sdl? ( media-libs/libsdl2:= )
	)
	qt5?
	(
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	tiff? ( media-libs/tiff:= )
	trace? ( dev-util/lttng-ust:= )
	udev? ( virtual/libudev:= )
	unwind? ( sys-libs/libunwind:= )
"
RDEPEND="
	${DEPEND}
	trace? ( dev-util/lttng-tools )
"
#BDEPEND="
#	doc?
#	(
#		app-text/doxygen[dot]
#		dev-python/sphinx
#		dev-texlive/texlive-latexextra
#	)
#"

src_configure() {
	local emesonargs=(
		# Broken for >=dev-pyhon/sphinx-7
		# $(meson_feature doc documentation)
		-Ddocumentation=disabled
		$(meson_feature libevent cam)
		$(meson_feature gstreamer)
		$(meson_feature qt5 qcam)
		$(meson_feature trace tracing)
		$(meson_use v4l2)
	)

	meson_src_configure "-Dpipelines=uvcvideo,ipu3"
}
