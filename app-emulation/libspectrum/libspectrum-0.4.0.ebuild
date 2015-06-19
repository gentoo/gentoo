# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/libspectrum/libspectrum-0.4.0.ebuild,v 1.3 2012/05/03 18:49:07 jdhore Exp $

DESCRIPTION="Spectrum emulation library"
HOMEPAGE="http://fuse-emulator.sourceforge.net/libspectrum.php"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="audiofile bzip2 zlib"

RDEPEND="zlib? ( sys-libs/zlib )
	bzip2? ( >=app-arch/bzip2-1.0 )
	>=dev-libs/glib-2
	audiofile? ( >=media-libs/audiofile-0.2.3 )"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

src_compile() {
	econf --with-glib \
	$(use_with audiofile libaudiofile) \
	|| die "econf failed!"
	emake || die "emake failed!"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog README THANKS doc/*.txt *.txt
	doman doc/libspectrum.3
}
