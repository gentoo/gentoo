# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional" # not optional until !kdelibs4support
inherit kde5

DESCRIPTION="Locate KIO slave"
HOMEPAGE="https://www.linux-apps.com/content/show.php/kio-locate?content=120965"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1460972255/120965-${P}.tar.gz"
# See also: https://github.com/reporter123/kio-locate/commits/master

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( AUTHORS ChangeLog )

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.7.patch"
	"${FILESDIR}/${P}-kf5port.patch"
)

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	!kde-misc/kio-locate:4
	sys-apps/mlocate
"
