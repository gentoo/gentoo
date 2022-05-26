# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

MY_PV="$(ver_rs 1- '')"

DESCRIPTION="Scalable icon theme called Nou"
HOMEPAGE="http://www.silvestre.com.ar/"
SRC_URI="mirror://gentoo/Nou-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	dodoc Nou/{AUTHORS,README}
	rm -f Nou/{AUTHORS,COPYING,DONATE,INSTALL,README,.icon-theme.cache}

	insinto /usr/share/icons
	doins -r Nou
}
