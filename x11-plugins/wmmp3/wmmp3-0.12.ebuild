# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Mp3 player dock app for WindowMaker; frontend to mpg123"
HOMEPAGE="http://www.dockapps.net/wmmp3"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

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
