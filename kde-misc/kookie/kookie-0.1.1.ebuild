# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="Manage recipes and shopping lists"
HOMEPAGE="http://www.kde-apps.org/content/show.php/Kookie?content=117806"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
