# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="de pl"
inherit kde4-base

MY_P=kde4-windeco-${P}-Source

DESCRIPTION="A window decoration for KDE"
HOMEPAGE="http://kde-look.org/content/show.php/Nitrogen?content=99551"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/99551-${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	kde-plasma/kwin:4
"

S=${WORKDIR}/${MY_P}

DOCS=( README )
