# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="Qt5 QML video sink plugin for GStreamer"
KEYWORDS="~amd64"
IUSE="+egl wayland +X"

REQUIRED_USE="
	wayland? ( egl )
"

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[egl?,opengl,wayland?,X?]
	media-libs/mesa[egl(+)?,X?]
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	egl? ( dev-qt/qtgui:5[eglfs] )
	wayland? ( dev-qt/qtwayland:5 )
	X? ( dev-qt/qtx11extras:5 )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/gst-dont-use-volatile-to-mean-atomic-1.18.4.patch"
)

GST_PLUGINS_BUILD_DIR="qt"
