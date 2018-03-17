# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a program that can sit between a serial port and an application"
HOMEPAGE="http://www.suspectclass.com/~sgifford/interceptty/"
SRC_URI="http://www.suspectclass.com/~sgifford/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( AUTHORS NEWS README TODO )

src_install() {
	default
	dobin "${PN}" "${PN}-nicedump"
	doman "${PN}.1"
	doman interceptty.1
	einstalldocs
}
