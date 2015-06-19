# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/hdaps_monitor/hdaps_monitor-0.3-r1.ebuild,v 1.2 2014/04/24 14:19:27 johu Exp $

EAPI=5
inherit kde4-base

DESCRIPTION="KDE-based monitor for the IBM HDAPS system"
HOMEPAGE="http://www.kde-look.org/content/show.php/HDAPS+monitor?content=103481"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/103481-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="$(add_kdebase_dep plasma-workspace)"
RDEPEND="${DEPEND}
	app-laptop/hdapsd"
