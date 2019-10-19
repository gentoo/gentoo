# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=6e4fb2f3fcfb453c5522c66457ac5ed8c3b1b05c

if [[ ${PV} != *9999* ]]; then
	if [[ -z ${COMMIT} ]]; then
		SRC_URI="https://gstreamer.freedesktop.org/src/qt-gstreamer/${P}.tar.xz"
	else
		URI_PREFIX="https://github.com/GStreamer/qt-gstreamer/archive"
		SRC_URI="${URI_PREFIX}/${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	fi
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
else
	EGIT_REPO_URI="https://github.com/GStreamer/qt-gstreamer.git"
	inherit git-r3
fi

inherit cmake-utils

DESCRIPTION="C++ bindings for GStreamer with a Qt-style API"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/qt-gstreamer.html"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-libs/boost:=
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	test? ( dev-qt/qttest:5 )
"

# bug 497880
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Declarative=ON
		-DQTGSTREAMER_EXAMPLES=OFF
		-DQTGSTREAMER_TESTS=$(usex test)
		-DQT_VERSION=5
	)
	cmake-utils_src_configure
}
