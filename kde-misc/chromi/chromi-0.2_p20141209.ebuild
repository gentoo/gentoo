# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/chromi/chromi-0.2_p20141209.ebuild,v 1.1 2014/12/10 09:33:31 kensington Exp $

EAPI=5

MY_P="kwin-deco-${PN}-${PV}"
inherit kde4-base

DESCRIPTION="Titlebar-less decoration inspired by Google Chrome and Nitrogen minimal mod"
HOMEPAGE="http://kde-look.org/content/show.php/Chromi?content=119069"
SRC_URI="http://dev.gentoo.org/~kensington/distfiles/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

DEPEND="
	$(add_kdebase_dep kwin)
"
RDEPEND="${DEPEND}"
