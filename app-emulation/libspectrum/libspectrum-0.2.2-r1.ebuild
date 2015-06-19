# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/libspectrum/libspectrum-0.2.2-r1.ebuild,v 1.7 2012/05/03 18:49:07 jdhore Exp $

DESCRIPTION="Spectrum emulation library"
HOMEPAGE="http://www.srcf.ucam.org/~pak21/spectrum/libspectrum.html"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc x86"

RDEPEND=">=dev-libs/glib-2
	dev-libs/libgcrypt
	dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	econf --with-glib || die
	emake -j1 || die "libspectrum make failed!"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog README THANKS doc/*.txt *.txt
}
