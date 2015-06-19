# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/chromi/chromi-0.2.ebuild,v 1.1 2013/06/17 22:24:11 creffett Exp $

EAPI=5
inherit kde4-base

DESCRIPTION="Titlebar-less decoration inspired by Google Chrome and Nitrogen minimal mod"
HOMEPAGE="http://kde-look.org/content/show.php/Chromi?content=119069"
SRC_URI="https://github.com/jinliu/kwin-deco-chromi/archive/v${PV}.zip -> ${P}.zip"

SLOT="4"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/kwin-deco-${P}"

PATCHES=( "${FILESDIR}/${PN}-0.2-add-kwin-decoration-api-version.patch" )

DEPEND="
	$(add_kdebase_dep kwin)
"
RDEPEND="${DEPEND}"
