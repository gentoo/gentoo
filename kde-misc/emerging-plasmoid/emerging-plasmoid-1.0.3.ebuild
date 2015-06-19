# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/emerging-plasmoid/emerging-plasmoid-1.0.3.ebuild,v 1.2 2014/04/10 11:16:11 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Portage emerge progress plasmoid"
HOMEPAGE="http://kde-apps.org/content/show.php/Emerging+Plasmoid?content=147414 "
SRC_URI="mirror://github/leonardo2d/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	dev-lang/perl
	dev-perl/DateManip
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"
