# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="a webcam software displaying ascii art using aalib"
HOMEPAGE="http://ascii.dyne.org"
SRC_URI="ftp://ftp.dyne.org/${PN}/releases/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/aalib"
RDEPEND="${DEPEND}
	media-fonts/font-misc-misc" #387909

DOCS=( AUTHORS ChangeLog NEWS README TODO )
