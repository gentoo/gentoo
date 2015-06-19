# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/kuroo4/kuroo4-0.90.5.ebuild,v 1.2 2015/06/04 19:00:36 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Graphical Portage frontend based on KDE4/Qt4"
HOMEPAGE="http://kuroo.sourceforge.net/"
SRC_URI="mirror://sourceforge/kuroo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="dev-db/sqlite"

RDEPEND="${DEPEND}
	app-portage/gentoolkit
	$(add_kdeapps_dep kdesu)
	$(add_kdeapps_dep kompare)
"
