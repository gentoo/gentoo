# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/hasciicam/hasciicam-1.1.1.ebuild,v 1.6 2014/08/10 20:59:43 slyfox Exp $

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
