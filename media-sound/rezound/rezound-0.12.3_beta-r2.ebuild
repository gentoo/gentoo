# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
MY_P=${P/_/}
PATCHLEVEL=6

inherit autotools eutils flag-o-matic

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc -sparc x86"
IUSE="16bittmp alsa flac jack nls oss portaudio soundtouch vorbis"

RDEPEND="=sci-libs/fftw-2*
	>=x11-libs/fox-1.6.19:1.6
	>=media-libs/audiofile-0.2.3
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/ladspa-cmt-1.15
	alsa? ( >=media-libs/alsa-lib-1.0 )
	flac? ( >=media-libs/flac-1.1.2[cxx] )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( >=media-libs/portaudio-18 )
	soundtouch? ( >=media-libs/libsoundtouch-1.2.1 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )"
DEPEND="${RDEPEND}
	sys-devel/bison
	virtual/pkgconfig
	sys-devel/flex
	dev-util/reswrap"

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	AT_M4DIR="config/m4" eautoreconf
}

src_configure() {
	# fix compilation errors on ppc, where some
	# of the required functions aren't defined
	use ppc && epatch "${FILESDIR}/undefined-functions.patch"

	# following features can't be disabled if already installed:
	# -> flac, oggvorbis, soundtouch
	local sampletype="--enable-internal-sample-type=float"
	use 16bittmp && sampletype="--enable-internal-sample-type=int16"

	# -O3 isn't safe wrt #275437
	replace-flags -O[3-9] -O2

	econf \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable soundtouch) \
		${sampletype} \
		--enable-ladspa \
		--enable-largefile
}

src_install() {
	make DESTDIR="${D}" install

	# remove wrong doc directory
	rm -rf "${D}/usr/doc"

	dodoc docs/{AUTHORS,NEWS,README*}
	dodoc docs/{TODO_FOR_USERS_TO_READ,*.txt}
	newdoc README README.rezound

	docinto code
	dodoc docs/code/*
	newicon src/images/icon_logo_32.gif rezound.gif
	make_desktop_entry rezound Rezound rezound.gif AudioVideo
}
