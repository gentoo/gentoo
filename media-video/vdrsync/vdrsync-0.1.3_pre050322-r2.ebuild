# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-${PV#*_pre}"

DESCRIPTION="converting vdr-recordings to mpeg2, dvd or other similar formats"
HOMEPAGE="http://vdrsync.vdr-portal.de/"
SRC_URI="http://vdrsync.vdr-portal.de/releases/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="dvdr"

DEPEND=""
RDEPEND=">=dev-lang/perl-5.8.0
	media-fonts/corefonts
	media-video/mjpegtools
	dvdr? (
		>=media-libs/gd-2.0.15
		>=dev-perl/GD-2.0.7
		>=dev-perl/GDTextUtil-0.86
		>=media-video/dvdauthor-0.6.8
	)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default
	sed -e "s:/usr/X11R6/lib/X11/fonts/truetype/arial.ttf:/usr/share/fonts/corefonts/arial.ttf:g" \
		-i dvd-menu.pl || die
	eapply "${FILESDIR}/${P}-path.diff"
}

src_install() {
	dobin check-vdrsync.pl vdrsync.pl vdrsync_buffer.pl
	use dvdr && dobin dvd-menu.pl
	dodoc CHANGES
}
