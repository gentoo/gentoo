# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/rtaudio/rtaudio-4.0.12-r1.ebuild,v 1.1 2014/06/22 00:57:30 radhermit Exp $

EAPI=5

inherit eutils autotools toolchain-funcs

DESCRIPTION="A set of cross-platform C++ classes for realtime audio I/O"
HOMEPAGE="http://www.music.mcgill.ca/~gary/rtaudio/"
SRC_URI="http://www.music.mcgill.ca/~gary/${PN}/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa doc jack pulseaudio static-libs"
REQUIRED_USE="|| ( alsa jack pulseaudio )"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? (
		media-libs/alsa-lib
		media-sound/jack-audio-connection-kit
	)
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0.11-cflags.patch
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-configure.patch

	if ! use static-libs ; then
		sed -i '/^LIBRARIES =/s/$(STATIC)//' Makefile.in || die
	fi

	eautoreconf
}

src_configure() {
	# OSS support requires OSSv4
	econf \
		--without-oss \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with pulseaudio pulse)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	dolib.so librtaudio.so*
	use static-libs && dolib.a librtaudio.a

	dobin rtaudio-config
	doheader *.h
	dodoc readme doc/release.txt

	if use doc ; then
		dohtml -r doc/html/*
		dodoc -r doc/images
	fi
}
