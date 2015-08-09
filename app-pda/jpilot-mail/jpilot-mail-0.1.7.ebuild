# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils multilib

MY_PN=jpilot-Mail

DESCRIPTION="jpilot-Mail is a jpilot plugin to deliver mail from the pilot and upload mail to it"
HOMEPAGE="http://ludovic.rousseau.free.fr/softwares/jpilot-Mail/"
SRC_URI="http://ludovic.rousseau.free.fr/softwares/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=app-pda/jpilot-0.99.7-r1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_configure() {
	econf \
		--enable-gtk2
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" \
		datadir="/usr/share/doc/${PF}/html" \
		libdir="/usr/$(get_libdir)/jpilot/plugins" \
		install || die

	dodoc AUTHORS ChangeLog README TODO

	find "${D}" -name '*.la' -exec rm -f {} +
}
