# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="A webcam software displaying ascii art using aalib"
HOMEPAGE="http://ascii.dyne.org/"
SRC_URI="http://ftp.dyne.org/${PN}/releases/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="media-libs/aalib
	net-libs/ftplib"
RDEPEND="${DEPEND}
	media-fonts/font-misc-misc" #387909

DOCS=( AUTHORS NEWS README TODO ) # ChangeLog is dead
