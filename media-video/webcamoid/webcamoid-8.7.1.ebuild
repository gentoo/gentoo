# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="A full featured webcam capture application"
HOMEPAGE="https://webcamoid.github.io"
SRC_URI="https://github.com/webcamoid/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE_AVKYS=( alsa coreaudio ffmpeg gstreamer jack libuvc oss pulseaudio qtaudio v4lutils videoeffects )
IUSE="${IUSE_AVKYS[@]} debug headers v4l"

REQUIRED_USE="v4lutils? ( v4l )"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	ffmpeg?	( media-video/ffmpeg:= )
	gstreamer? ( >=media-libs/gstreamer-1.6.0 )
	jack? ( virtual/jack )
	libuvc? ( media-libs/libuvc )
	pulseaudio? ( media-sound/pulseaudio )
	qtaudio? ( dev-qt/qtmultimedia:5 )
	v4l? ( media-libs/libv4l )
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.6
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-8.7.1-gcc11.patch
)

src_configure() {
	local myqmakeargs=(
		"CONFIG+=debug"
		"PREFIX=/usr"
		"BUILDDOCS=0"
		"INSTALLDEVHEADERS=$(usex headers 1 0)"
		"INSTALLQMLDIR=$(qt5_get_libdir)/qt5/qml"
		"LIBDIR=/usr/$(get_libdir)"
		"NOAVFOUNDATION=1"
		"NODSHOW=1"
		"NOVCAMWIN=1"
		"NOWASAPI=1"
	)

	use v4l || myqmakeargs+=( "NOV4L2=1" )

	for x in ${IUSE_AVKYS[@]}; do
		use ${x} || myqmakeargs+=( "NO${x^^}=1" )
	done

	eqmake5 ${myqmakeargs[@]}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
