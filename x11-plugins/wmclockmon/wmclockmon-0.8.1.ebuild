# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmclockmon/wmclockmon-0.8.1.ebuild,v 1.9 2014/08/10 20:05:22 slyfox Exp $

EAPI=5
inherit eutils

DESCRIPTION="a nice digital clock with 7 different styles either in LCD or LED style"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libICE"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	x11-libs/libXt"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gtk.patch
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/sample*
	newdoc debian/changelog ChangeLog.debian
}
