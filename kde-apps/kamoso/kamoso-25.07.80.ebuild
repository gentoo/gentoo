# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Application to take pictures and videos from your webcam"
HOMEPAGE="https://apps.kde.org/kamoso/ https://userbase.kde.org/Kamoso"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv"
IUSE=""

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/purpose-${KFMIN}:6
	media-libs/gst-plugins-base:1.0
	virtual/opengl
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
	media-plugins/gst-plugins-jpeg:1.0
	media-plugins/gst-plugins-libpng:1.0
	media-plugins/gst-plugins-meta:1.0[alsa,theora,vorbis,v4l]
	media-plugins/gst-plugins-qt6:1.0
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DPATCHED_GSTREAMER=ON
	)

	ecm_src_configure
}
