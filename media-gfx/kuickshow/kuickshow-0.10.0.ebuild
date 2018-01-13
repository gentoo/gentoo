# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_DOC_DIRS="doc doc-translations/%lingua"
inherit kde5

DESCRIPTION="Image viewer based on KDE Frameworks"
HOMEPAGE="https://userbase.kde.org/KuickShow"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( AUTHORS BUGS ChangeLog README TODO )

DEPEND="
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kdoctools)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtx11extras)
	media-libs/imlib
"
RDEPEND="
	${DEPEND}
	!${CATEGORY}/${PN}:4
"
