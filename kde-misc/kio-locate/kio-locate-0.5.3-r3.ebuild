# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional" # not optional until !kdelibs4support
inherit ecm

DESCRIPTION="Locate KIO slave"
HOMEPAGE="https://www.linux-apps.com/content/show.php/kio-locate?content=120965"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1460972255/120965-${P}.tar.gz"
# See also: https://github.com/reporter123/kio-locate/commits/master

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.7.patch"
	"${FILESDIR}/${P}-kf5port.patch"
)

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kdelibs4support:5
	kde-frameworks/ki18n:5
	kde-frameworks/kiconthemes:5
	kde-frameworks/kio:5
	kde-frameworks/kwidgetsaddons:5
"
RDEPEND="${DEPEND}
	sys-apps/mlocate
"
