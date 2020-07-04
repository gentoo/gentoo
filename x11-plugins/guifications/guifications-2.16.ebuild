# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=pidgin-${PN}
MY_PV=${PV/_beta/beta}
MY_P=${MY_PN}-${MY_PV}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Guifications is a graphical notification plugin for pidgin"
HOMEPAGE="http://plugins.guifications.org/"
SRC_URI="http://downloads.guifications.org/plugins//Guifications2/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="debug nls"

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2"

DEPEND="${DEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable debug ) \
		$(use_enable nls)
}
