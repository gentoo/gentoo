# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/serverstatuswidget/serverstatuswidget-1.5.1.ebuild,v 1.2 2014/03/21 19:06:33 johu Exp $

EAPI=5

KDE_LINGUAS="de fr"
inherit kde4-base

DESCRIPTION="KDE plasma widget used for monitoring servers via ping or tcp connect"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=101336"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/101336-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
