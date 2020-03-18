# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="phonon-backend-gstreamer"
inherit ecm kde.org

DESCRIPTION="GStreamer backend for the Phonon multimedia library"
HOMEPAGE="https://phonon.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="alsa debug +network"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	>=media-libs/phonon-4.10.60
	media-plugins/gst-plugins-meta:1.0[alsa?,ogg,vorbis]
	virtual/opengl
"
RDEPEND="${DEPEND}
	network? ( media-plugins/gst-plugins-soup:1.0 )
"

S="${WORKDIR}/${MY_PN}-${PV}"
