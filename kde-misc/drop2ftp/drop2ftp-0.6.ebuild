# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Plasmoid to add files over KIO supported protocols, like ftp and ssh"
HOMEPAGE="http://www.kde-look.org/content/show.php/Drop2FTP?content=97281"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/97281-${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	kde-plasma/plasma-workspace:4
"

PATCHES=( "${FILESDIR}/${P}-qt47.patch" )
