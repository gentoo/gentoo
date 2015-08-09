# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Kool Gorilla Icon Set for KDE"
SRC_URI="http://home.comcast.net/~gorillaonkde/gorilla/Korilla_Icons-v${PV}.tar.bz2"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=7264"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

S="${WORKDIR}"

RESTRICT="binchecks strip"

src_install(){
	insinto /usr/share/icons/
	doins -r Kool.Gorilla
}
