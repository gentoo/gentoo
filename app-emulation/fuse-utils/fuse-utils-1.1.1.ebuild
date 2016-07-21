# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Utils for the Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audiofile gcrypt"

RDEPEND="~app-emulation/libspectrum-1.1.1[gcrypt?]
	audiofile? ( >=media-libs/audiofile-0.2.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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
