# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
ECM_HANDBOOK="forceoptional"
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm gear.kde.org

DESCRIPTION="Application to take pictures and videos from your webcam by KDE"
HOMEPAGE="https://apps.kde.org/kamoso/ https://userbase.kde.org/Kamoso"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"
IUSE=""

RESTRICT="test" # bug 653674

COMMON_DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/purpose-${KFMIN}:5
	media-libs/gst-plugins-base:1.0
	virtual/opengl
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qtopengl-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	media-plugins/gst-plugins-jpeg:1.0
	media-plugins/gst-plugins-libpng:1.0
	media-plugins/gst-plugins-meta:1.0[alsa,theora,vorbis,v4l]
"
BDEPEND="virtual/pkgconfig"
