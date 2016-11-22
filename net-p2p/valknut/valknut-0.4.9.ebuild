# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="A open source cross platform client for the Direct Connect network"
HOMEPAGE="https://sourceforge.net/projects/wxdcgui/"
SRC_URI="mirror://sourceforge/wxdcgui/${P}.tar.bz2
	gnome? ( mirror://sourceforge/wxdcgui/${P}-gnome-icons.tar.gz )
	kde? ( mirror://sourceforge/wxdcgui/${P}-oxygen-icons.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="gnome kde"

RDEPEND="dev-qt/qtgui:4[qt3support]
	>=net-p2p/dclib-0.3.23"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO

	insinto /usr/share/${PN}/icons/appl

	if use gnome; then
		doins -r "${WORKDIR}"/${P}-gnome-icons/gnome
	fi

	if use kde; then
		doins -r "${WORKDIR}"/${P}-oxygen-icons/oxygen
	fi
}
