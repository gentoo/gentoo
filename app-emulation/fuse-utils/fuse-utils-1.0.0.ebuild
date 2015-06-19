# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/fuse-utils/fuse-utils-1.0.0.ebuild,v 1.3 2012/05/03 18:49:07 jdhore Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="Utils for the Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audiofile gcrypt"

RDEPEND="~app-emulation/libspectrum-1.0.0[gcrypt?]
	audiofile? ( >=media-libs/audiofile-0.2.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare () {
	epatch "${FILESDIR}/${P}-libgcrypt.patch"
	eautoreconf
}

src_configure() {
	econf \
	$(use_with audiofile ) \
	$(use_with gcrypt libgcrypt) \
	|| die "Configure failed!"
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog README
	doman man/*.1
}
