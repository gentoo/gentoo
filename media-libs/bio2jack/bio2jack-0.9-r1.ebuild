# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/bio2jack/bio2jack-0.9-r1.ebuild,v 1.9 2012/05/05 08:02:45 jdhore Exp $

EAPI=4
inherit autotools

DESCRIPTION="A library for porting blocked I/O OSS/ALSA audio applications to JACK"
HOMEPAGE="http://bio2jack.sourceforge.net/"
SRC_URI="mirror://sourceforge/bio2jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs"

RDEPEND="media-libs/libsamplerate
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	# upstream does not provide a real release, it releases a tarball
	# with a _prebuilt_ copy of bio2jack. Drop all of the built stuff
	# and recreate autotools from scratch, then build.
	rm -rf *.a *.o *.la *.lo .libs .deps Makefile config.{log,status} stamp-h1 stamp || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dobin bio2jack-config
	dodoc AUTHORS ChangeLog NEWS README
	rm -f "${ED}"usr/lib*/lib*.la
}
