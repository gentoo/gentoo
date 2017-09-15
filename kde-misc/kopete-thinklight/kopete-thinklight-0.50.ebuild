# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="A ThinkPad's light flash on every incoming message"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=100537"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/100537-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kopete)
"
DEPEND="${RDEPEND}"

DOCS=( CREDITS )
