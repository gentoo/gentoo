# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Psi/Psi+ plugin for voice/video calls"
HOMEPAGE="https://psi-im.org/"

EGIT_REPO_URI="https://github.com/psi-im/psimedia.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="demo extras +psi"
REQUIRED_USE="extras? ( psi )"

DEPEND="
	dev-libs/glib
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
"
RDEPEND="${DEPEND}
	media-plugins/gst-plugins-jpeg:1.0
	media-plugins/gst-plugins-opus:1.0
	media-plugins/gst-plugins-v4l2:1.0
	psi? ( ~net-im/psi-${PV}[extras?] )
"
# and optional media-plugins/gst-plugins-webrtcdsp:1.0 for echo cancellation

src_configure() {
	local mycmakeargs=(
		-DUSE_PSI=$(usex extras)
		-DBUILD_DEMO=$(usex demo)
		-DBUILD_PSIPLUGIN=$(usex psi)
	)
	cmake_src_configure
}
