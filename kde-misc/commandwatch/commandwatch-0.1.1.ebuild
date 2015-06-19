# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/commandwatch/commandwatch-0.1.1.ebuild,v 1.1 2013/06/17 22:37:55 creffett Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE4 plasmoid which periodically runs a system command and displays its output"
HOMEPAGE="http://www.kde-look.org/content/show.php/Command+Watch?content=84523"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/84523-${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"
