# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="phonon-backend-vlc"
inherit kde5

DESCRIPTION="VLC backend for the Phonon multimedia library"
HOMEPAGE="https://phonon.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=media-libs/phonon-4.10.60
	media-video/vlc:=[dbus,ogg,vorbis]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
