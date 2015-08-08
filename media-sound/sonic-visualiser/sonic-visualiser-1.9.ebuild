# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils qt4-r2 autotools fdo-mime

DESCRIPTION="Music audio files viewer and analiser"
HOMEPAGE="http://www.sonicvisualiser.org/"
SRC_URI="http://code.soundsoftware.ac.uk/attachments/download/194/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fftw id3tag jack mad ogg osc +portaudio pulseaudio"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/libsndfile
	media-libs/libsamplerate
	fftw? ( sci-libs/fftw:3.0 )
	app-arch/bzip2
	>=media-libs/dssi-0.9.1
	media-libs/liblrdf
	dev-libs/redland
	media-libs/ladspa-sdk
	osc? ( media-libs/liblo )
	media-libs/speex
	>=media-libs/vamp-plugin-sdk-2.0
	media-libs/rubberband
	jack? ( media-sound/jack-audio-connection-kit )
	mad? ( media-libs/libmad )
	id3tag? ( media-libs/libid3tag )
	ogg? ( media-libs/libfishsound >=media-libs/liboggz-1.1.0 )
	portaudio? ( >=media-libs/portaudio-19_pre20071207 )
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="|| ( jack pulseaudio portaudio )"

sv_disable_opt() {
	einfo "Disabling $1"
	for i in sonic-visualiser svapp svcore svgui ; do
		sed -i -e "/$1/d" "${S}/$i/configure.ac" || die "failed to remove $1 support"
	done
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.8-configure.patch
	epatch "${FILESDIR}"/${PN}-1.9-gcc47.patch
	cd svcore
	epatch "${FILESDIR}"/${PN}-1.7.1-liboggz11.patch

	use fftw || sv_disable_opt fftw3f
	use fftw || sv_disable_opt fftw3
	use id3tag || sv_disable_opt id3tag
	use jack || sv_disable_opt jack
	use mad || sv_disable_opt mad
	use ogg || sv_disable_opt fishsound
	use ogg || sv_disable_opt oggz
	use osc || sv_disable_opt liblo
	use portaudio || sv_disable_opt portaudio
	use pulseaudio || sv_disable_opt libpulse

	for i in sonic-visualiser svapp svcore svgui ; do
	   pushd "${S}"/$i > /dev/null
	   eautoreconf
	   popd > /dev/null
	done
}

src_install() {
	cd ${PN}
	dobin ${PN}
	dodoc README*
	#install samples
	insinto /usr/share/${PN}/samples
	doins samples/*
	# desktop entry
	doicon icons/sv-icon.svg
	domenu *.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
