# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/hasciicam/hasciicam-1.1.2.ebuild,v 1.2 2011/12/22 18:17:05 ssuominen Exp $

EAPI=4

DESCRIPTION="A webcam software displaying ascii art using aalib"
HOMEPAGE="http://ascii.dyne.org/"
SRC_URI="http://ftp.dyne.org/${PN}/releases/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/aalib
	net-libs/ftplib"
RDEPEND="${DEPEND}
	media-fonts/font-misc-misc" #387909

DOCS=( AUTHORS NEWS README TODO ) # ChangeLog is dead
