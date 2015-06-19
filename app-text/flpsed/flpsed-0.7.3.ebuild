# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/flpsed/flpsed-0.7.3.ebuild,v 1.1 2015/06/04 09:21:10 aballier Exp $

EAPI=5

inherit eutils

DESCRIPTION="Pseudo PostScript editor"
HOMEPAGE="http://www.ecademix.com/JohannesHofmann/"
SRC_URI="http://www.ecademix.com/JohannesHofmann/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	>=x11-libs/fltk-1.3.0:1
	app-text/ghostscript-gpl[X]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.2-desktop.patch
}

src_install() {
	default

	doicon ${PN}.png
	doicon -s scalable ${PN}.svg
	domenu ${PN}.desktop
}
