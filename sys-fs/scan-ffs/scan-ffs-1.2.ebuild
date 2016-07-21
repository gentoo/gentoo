# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit bsdmk

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Recovers lost disklabel"
HOMEPAGE="http://www.ranner.eu/projects/"
SRC_URI="http://www.ranner.eu/stuff/${MY_P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	bsdmk_src_install
	dodoc README ChangeLog
}
