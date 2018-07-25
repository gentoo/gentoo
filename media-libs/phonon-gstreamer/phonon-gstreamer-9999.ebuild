# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="phonon-backend-gstreamer"
MY_P=${MY_PN}-${PV}

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	inherit git-r3
fi

inherit cmake-utils

DESCRIPTION="Phonon GStreamer backend"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="alsa debug +network"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/phonon-4.10.0
	media-plugins/gst-plugins-meta:1.0[alsa?,ogg,vorbis]
	virtual/opengl
	network? ( media-plugins/gst-plugins-soup:1.0 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=( -DPHONON_BUILD_PHONON4QT5=ON )
	cmake-utils_src_configure
}
