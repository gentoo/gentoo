# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils

DESCRIPTION="A GTK program for doing Smith Chart calculations"
HOMEPAGE="http://www.qsl.net/ik5nax/"
SRC_URI="http://www.qsl.net/ik5nax/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-autotools.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README TODO
	insinto /usr/share/${PN}
	doins example*
}
