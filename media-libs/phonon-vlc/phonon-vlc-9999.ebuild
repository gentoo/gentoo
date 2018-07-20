# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="phonon-backend-vlc"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
else
	EGIT_REPO_URI=( "git://anongit.kde.org/${PN}" )
	inherit git-r3
fi

inherit cmake-utils

DESCRIPTION="Phonon VLC backend"
HOMEPAGE="https://phonon.kde.org/"

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=media-libs/phonon-4.10.0
	media-video/vlc:=[dbus,ogg,vorbis]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=( -DPHONON_BUILD_PHONON4QT5=ON )
	cmake-utils_src_configure
}
