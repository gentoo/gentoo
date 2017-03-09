# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Jukebox and music manager by KDE"
HOMEPAGE="https://www.kde.org/applications/multimedia/juk/"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="
	media-libs/phonon[qt4]
	>=media-libs/taglib-1.6
"
RDEPEND="${DEPEND}"

src_configure() {
	# bug 410551: for disabling deprecated TunePimp support
	local mycmakeargs=(
		-DWITH_TunePimp=OFF
	)

	kde4-base_src_configure
}
