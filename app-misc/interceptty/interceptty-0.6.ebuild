# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="a program that can sit between a serial port and an application"
HOMEPAGE="http://www.suspectclass.com/~sgifford/interceptty/"
SRC_URI="http://www.suspectclass.com/~sgifford/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	into /usr
	dobin interceptty interceptty-nicedump || die
	dodoc AUTHORS NEWS README TODO
	doman interceptty.1
}
