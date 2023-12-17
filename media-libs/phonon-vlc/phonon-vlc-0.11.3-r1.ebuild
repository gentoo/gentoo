# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="phonon-backend-vlc"
inherit ecm kde.org

DESCRIPTION="VLC backend for the Phonon multimedia library"
HOMEPAGE="https://community.kde.org/Phonon"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/phonon/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.xz"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=media-libs/phonon-4.11.0[qt5(+)]
	media-video/vlc:=[dbus,ogg,vorbis(+)]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
