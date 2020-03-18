# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Flat SVG icon set"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=17158"
SRC_URI="http://www.atqu23.dsl.pipex.com/danny/flatSVG${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

S=${WORKDIR}/FlatSVG

src_install() {
	insinto /usr/share/icons
	doins -r "${S}"
}
