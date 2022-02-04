# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Scalable icon theme called Yasis"
HOMEPAGE="http://www.silvestre.com.ar/"
SRC_URI="mirror://gentoo/yasis-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	dodoc yasis/{AUTHORS,README}
	rm -f yasis/{AUTHORS,COPYING,DONATE,INSTALL,README}

	insinto /usr/share/icons
	doins -r yasis
}
