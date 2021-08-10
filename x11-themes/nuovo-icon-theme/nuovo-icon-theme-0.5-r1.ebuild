# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A scalable icon theme called Nuovo"
HOMEPAGE="http://www.silvestre.com.ar/"
SRC_URI="mirror://gentoo/dlg-nuovo-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	dodoc Nuovo/{AUTHORS,Changelog,README}
	rm -f Nuovo/{AUTHORS,Changelog,COPYING,DONATE,INSTALL,README}

	insinto /usr/share/icons
	doins -r Nuovo
}
