# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvd9to5/dvd9to5-0.1.7.ebuild,v 1.8 2006/08/30 14:19:53 zzam Exp $

DESCRIPTION="Perl script to backup the main feature of a DVD-9 on DVD-5"
HOMEPAGE="http://lakedaemon.netmindz.net/dvd9to5/"
SRC_URI="http://lakedaemon.netmindz.net/dvd9to5/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RDEPEND=">=media-video/transcode-0.6.11
	>=media-video/mjpegtools-1.6.2
	>=media-video/dvdauthor-0.6.10
	app-cdr/dvd+rw-tools
	dev-lang/perl"

src_compile() {
	true # nothing to do
}

src_install() {
	dobin dvd9to5.pl
	dodoc CHANGELOG README TODO dvd9to5.conf.example
}
