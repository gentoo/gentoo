# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/coquillo/coquillo-1.12.ebuild,v 1.2 2013/03/02 21:54:25 hwoarang Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="GUI audio tagger based on Qt4 and taglib"
HOMEPAGE="http://qt-apps.org/content/show.php/Coquillo?content=141896"
SRC_URI="http://cs.joensuu.fi/~sjuvonen/${PN}/${PV}/${P}-src.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/taglib-1.7
	>=dev-qt/qtgui-4.6:4
	>=dev-qt/qtcore-4.6:4"
RDEPEND="${DEPEND}"
