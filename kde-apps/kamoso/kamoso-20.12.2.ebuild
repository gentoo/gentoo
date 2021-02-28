# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.75.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Application to take pictures and videos from your webcam by KDE"
HOMEPAGE="https://apps.kde.org/en/kamoso https://userbase.kde.org/Kamoso"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
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
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	media-plugins/gst-plugins-jpeg:1.0
	media-plugins/gst-plugins-libpng:1.0
	media-plugins/gst-plugins-meta:1.0[alsa,theora,vorbis,v4l]
"

RESTRICT+=" test" # bug 653674
