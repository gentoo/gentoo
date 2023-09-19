# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Perl script to backup the main feature of a DVD-9 on DVD-5"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://bluray.beandog.org/dvd9to5/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	app-cdr/dvd+rw-tools
	dev-lang/perl
	>=media-video/dvdauthor-0.6.10
	>=media-video/mjpegtools-1.6.2
	>=media-video/transcode-0.6.11"

src_install() {
	dobin dvd9to5.pl
	dodoc CHANGELOG README TODO dvd9to5.conf.example
}
