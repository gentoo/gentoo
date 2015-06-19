# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmp3/wmmp3-0.12.ebuild,v 1.15 2014/09/01 15:26:27 voyageur Exp $

inherit eutils

IUSE=""

DESCRIPTION="Mp3 player dock app for WindowMaker; frontend to mpg123"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/60"
SRC_URI="http://dockapps.windowmaker.org/download.php/id/91/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	media-sound/mpg123"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix #103531
	epatch "${FILESDIR}"/${P}-x_includes_n_libraries.patch
}

src_compile() {
	# override wmmp3 self-calculated cflags
	econf
	emake prefix="/usr/" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog sample.wmmp3 README TODO
}

pkg_postinst() {
	einfo "Please copy the sample.wmmp3 to your home directory and change it to fit your needs."
}
