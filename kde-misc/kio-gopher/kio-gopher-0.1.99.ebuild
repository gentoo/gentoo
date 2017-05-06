# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Gopher Kioslave for Konqueror"
HOMEPAGE="https://userbase.kde.org/Kio_gopher"
SRC_URI="mirror://kde/unstable/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
"
RDEPEND="${DEPEND}
	!kde-misc/kio-gopher:4
"
