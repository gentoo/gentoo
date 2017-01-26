# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Plasmoid which periodically runs a system command and displays its output"
HOMEPAGE="http://www.kde-look.org/content/show.php/Command+Watch?content=84523"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/84523-${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	kde-plasma/plasma-workspace:4
"
