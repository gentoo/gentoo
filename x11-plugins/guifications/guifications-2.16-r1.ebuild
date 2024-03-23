# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="pidgin-${PN}"
MY_PV="${PV/_beta/beta}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Guifications is a graphical notification plugin for pidgin"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://downloads.guifications.org/plugins//Guifications2/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug nls"

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable debug ) \
		$(use_enable nls)
}

src_install() {
	default

	find "${D}" -type f -name '*.la' -delete || die "la removal failed"
}
