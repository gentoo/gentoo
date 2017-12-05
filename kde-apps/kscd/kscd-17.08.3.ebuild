# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="KDE CD player"
HOMEPAGE="https://www.kde.org/applications/multimedia/kscd/"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	media-libs/libdiscid
	media-libs/musicbrainz:5
	media-libs/phonon[qt4]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-musicbrainz5.patch" )
