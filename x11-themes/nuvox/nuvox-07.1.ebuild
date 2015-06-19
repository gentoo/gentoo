# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/nuvox/nuvox-07.1.ebuild,v 1.4 2012/01/23 10:43:31 ssuominen Exp $

EAPI=4

MY_P=nuvoX_${PV}

DESCRIPTION="NuvoX SVG icon theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=38467"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[imagemagick,png] )"

RESTRICT="strip binchecks"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e '/rm -fr/d' -e '/tar cf/d' buildset || die
}

src_compile() {
	./buildset || die
}

src_install() {
	dodoc nuvoX_0.7/readme.txt
	rm nuvoX_0.7/{readme,license}.txt

	insinto /usr/share/icons/${PN}
	doins -r nuvoX_0.7/*
}
