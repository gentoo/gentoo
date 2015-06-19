# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/bkodama/bkodama-0.3.1.ebuild,v 1.4 2014/03/20 21:50:51 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A friendly, yet very simple-minded Kodama (Japanese ghost) wandering on your desktop"
HOMEPAGE="http://kde-look.org/content/show.php/bkodama?content=106528"
SRC_URI="http://kde-look.org/CONTENT/content-files/106528-${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"
DEPEND="${RDEPEND}"
